PORT   = 8080
DOMAIN = 'noname'

server: init 
	@hexo s -p $(PORT)
	
deploy_cname: init
	@cd public/ && \
	touch CNAME && echo $(DOMAIN) > CNAME && \
	echo "Start deploy ..." && \
	hexo d
	
deploy: init
	@echo "Start deploy ..." && \
	hexo d
	
init:
	@echo "Initializing ..." && \
	hexo clean && \
	hexo g
