test:
	vim '+Vader!* test/*' && echo Success || echo Failure

.PHONY: test
