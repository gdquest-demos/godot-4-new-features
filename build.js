#!/usr/bin/env node
//@ts-check

const insertBanner = () => {
  const fs = require('fs');
  const index = fs.readFileSync("exports/public/index.html", "utf-8")
  
  if(index.indexOf("<div class=\"banner-container\"") < 0){
    const banner = fs.readFileSync("static/banner.html", "utf-8")
    const editedIndex = index.replace(/(<body.*?\n)/, "$1"+banner)
    fs.writeFileSync("exports/public/index.html", editedIndex)
    console.log("Updated index.html")
  }
  else{
    console.log("index.html already has banner")
  }
}

const removeZipFiles = () => {
  const fs = require('fs')
  fs.readdirSync('exports/public').forEach(file => {
    const extension = require('path').extname(file).toLowerCase()
    if(extension === '.zip') {
      const filePath = require('path').join('exports/public', file)
      fs.unlinkSync(filePath)
    }
  })
  console.log("deleted exports/public/*.zip")
}

const build = () => {
  return exec('gwee',
    `build`,
    `-b rc6`,
    `. `,
    `-g`,
    `-p x11,win,osx`
  )
}

const pushReleases = async () => {
  console.log("Pushing releases... This takes time and there's no update monitor, please be patient")
  await exec(`gh`, `release`, `create`, `test`, `public/*.zip`, `--generate-notes`)
  console.log("Releases pushed")
}

const pushToGHPages = async () => {
  const scriptText = `#!/usr/bin/env bash

export BUILD_DIR="exports/public"
export RELEASE_BRANCH="gh-pages"

git fetch origin $RELEASE_BRANCH || git checkout -b $RELEASE_BRANCH
git add -f $BUILD_DIR
tree=$(git write-tree --prefix=$BUILD_DIR)
git reset -- $BUILD_DIR
export identifier=$(git describe --dirty --always)

git push -u origin $RELEASE_BRANCH
export commit=$(git commit-tree -p refs/remotes/origin/$RELEASE_BRANCH -m "Deploy $identifier" $tree)
git update-ref refs/heads/$RELEASE_BRANCH $commit
git push origin refs/heads/$RELEASE_BRANCH
git checkout main`

  const fs = require('fs')
  const scriptDir = fs.mkdtempSync('gh-pages')
  const scriptPath = require('path').join(scriptDir, 'gh-pages.sh')
  fs.writeFileSync(scriptPath, scriptText, "utf-8")
  console.log("Writing to gh-pages")
  exec(`bash`, scriptPath)
  console.log("Written to gh-pages")
}


const exec = (command, ...args) => /** @type {Promise<void>} */(new Promise((resolve, reject) => {
  const spawn = require('child_process').spawn;
  console.log(`Executing:\n${command} ${args.join(' ')}`);
  const stream = spawn(command, args, { shell: true });

    
  stream.stdout.on('data', (data) => {
    process.stdout.write(data.toString());
  });

  stream.stderr.on('data', (data) => {
    process.stderr.write(data.toString());
  });

  stream.on('error', reject)

  stream.on('close', (code) => {
    if(code !== 0){
      return reject(new Error(`${command} exited with code ${code}`));
    }
    resolve()
  }); 
}));


(async function doTheThing(){

    await build()
    await insertBanner()
    await removeZipFiles()
    await pushReleases()
    //await pushToGHPages()
})()