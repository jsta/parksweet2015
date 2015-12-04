data/%.csv: R/get_data.R
	Rscript -e "source('R/get_data.R')"
	
data/wlevel_trend.csv: R/calc_trend.R
	Rscript -e "source('R/calc_trend.R')"

render_products: data/%.csv data/wlevel_trend.csv
	Rscript -e "rmarkdown::render('parksweet2015.Rmd')"
	
all: data/%.csv data/wlevel_trend.csv render_products
	echo "complete"
	
clean:
	rm parksweet2015.html
	rm -rf parksweet2015_cache
	