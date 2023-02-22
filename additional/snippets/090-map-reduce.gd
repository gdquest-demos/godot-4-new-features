var bundle_name := "Mega Bundle"
var products := []



func get_bundle_price():
	return products.reduce(
		func(price, product):
			return price + product.price
	, 0
	)



func get_product_names():
	return products.map(
		func(product):
			return product.name
	)



func get_highest_rated_product():
	products.sort_custom(
		func(product_a, product_b):
			return product_a.stars > product_b.stars
	)
	return products



func get_beginners_products():
	return products.filter(
		func(product):
			return product.audience == "beginners"
	)
