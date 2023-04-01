# Get changed file (staged/un-staged) list from git
DIFF_PY_FILES :=  $(shell git status --porcelain | grep -E "^M|A|C|U|T|\?\?" | grep -E "\.py$$" | awk '{print $$2}')
DIFF_YAML_FILES :=  $(shell git status --porcelain | grep -E "^M|A|C|U|T|\?\?" | grep -E "\.ya?ml$$" | awk '{print $$2}' | grep -E -v ".*cassettes.*")



define PRINT_FILES
@echo "$(1) files to format/lint: "
@echo "-------------------"
@echo $(2) | tr ' ' '\n' | column -t
@echo "-------------------"
endef

.PHONY: setup
setup:
	@chmod +x ./install_pyenv.sh
	@./install_pyenv.sh
	@echo "installing poetry"
	@curl -sSL https://install.python-poetry.org | python3 -

.PHONY:  install
install:
	@echo "poetry installing..."
	@echo poetry install --no-ansi
	@echo "poetry installing...done"
	@echo "enable pre-commit"
	@echo poetry run pre-commit install


.PHONY: format
format:
ifeq ($(DIFF_PY_FILES),)
	@echo "no python files to format"
else
	$(call PRINT_FILES,python,$(DIFF_PY_FILES))
	@poetry run black $(DIFF_PY_FILES)
endif


.PHONY: lint
lint:
ifeq ($(DIFF_PY_FILES),)
	@echo "no python files to lint"
else
	$(call PRINT_FILES,python,$(DIFF_PY_FILES))
	@poetry run ruff check --fix $(DIFF_PY_FILES)
endif
ifeq ($(DIFF_YAML_FILES),)
	@echo "no yaml files to lint"
else
	$(call PRINT_FILES,yaml,$(DIFF_YAML_FILES))
	@poetry run yamllint $(DIFF_YAML_FILES)
endif

.PHONY: tests
tests:
	@poetry run pytest --cov-report=term-missing:skip-covered --cov=sentinel tests/

.PHONY: ci_format
ci_format:
ifeq ($(DIFF_ALL_PY_FILES),)
	@echo "no python files to format"
else
	$(call PRINT_FILES,python,$(DIFF_ALL_PY_FILES))
	@poetry run black $(DIFF_ALL_PY_FILES)
endif

.PHONY: ci_lint
ci_lint:
ifeq ($(DIFF_ALL_PY_FILES),)
	@echo "no python files to lint"
else
	$(call PRINT_FILES,python,$(DIFF_ALL_PY_FILES))
	@poetry run ruff check --fix $(DIFF_ALL_PY_FILES)
endif
ifeq ($(DIFF_ALL_YAML_FILES),)
	@echo "no yaml files to lint"
else
	$(call PRINT_FILES,yaml,$(DIFF_ALL_YAML_FILES))
	@poetry run yamllint $(DIFF_ALL_YAML_FILES)
endif