help:
	@echo '                                                                                     '
	@echo 'Makefile for the edX ecommerce project.                                              '
	@echo '                                                                                     '
	@echo 'Usage:                                                                               '
	@echo '    make requirements                 install requirements for local development     '
	@echo '    make migrate                      apply migrations                               '
	@echo '    make serve                        start the dev server at localhost:8002         '
	@echo '    make clean                        delete generated byte code and coverage reports'
	@echo '    make test_python                  run unit tests with migrations disabled        '
	@echo '    make quality                      run pep8 and pylint                            '
	@echo '    make validate                     run unit tests, followed by quality checks     '
	@echo '    make html_coverage                generate and view HTML coverage report         '
	@echo '    make accept                       run acceptance tests                           '
	@echo '    make extract_translations         extract strings to be translated               '
	@echo '    make dummy_translations           generate dummy translations                    '
	@echo '    make compile_translations         generate translation files                     '
	@echo '    make fake_translations            install fake translations                      '
	@echo '    make pull_translations            pull translations from Transifex               '
	@echo '    make update_translations          install new translations from Transifex        '
	@echo '                                                                                     '

requirements:
	pip install -qr requirements/local.txt --exists-action w
	pip install -qr requirements/test.txt --exists-action w

migrate:
	python manage.py migrate

serve:
	python manage.py runserver 8002

clean:
	find . -name '*.pyc' -delete
	coverage erase

test_python: clean
	DISABLE_MIGRATIONS=True python manage.py test ecommerce --settings=ecommerce.settings.test --with-coverage \
	--cover-package=ecommerce --with-ignore-docstrings

quality:
	pep8 --config=.pep8 ecommerce acceptance_tests
	pylint --rcfile=pylintrc ecommerce acceptance_tests

validate: test_python quality

html_coverage:
	coverage html && open htmlcov/index.html

accept:
	nosetests --with-ignore-docstrings -v acceptance_tests

extract_translations:
	cd extensions && i18n_tool extract -v

dummy_translations:
	cd extensions && i18n_tool dummy -v

compile_translations:
	cd extensions && i18n_tool generate -v

fake_translations: extract_translations dummy_translations compile_translations

pull_translations:
	cd extensions && tx pull -a

update_translations: pull_translations generate_fake_translations

# Targets in a Makefile which do not produce an output file with the same name as the target name
.PHONY: help requirements migrate serve clean test_python quality validate html_coverage accept \
	extract_translations dummy_translations compile_translations fake_translations pull_translations update_translations
