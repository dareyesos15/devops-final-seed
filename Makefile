PYTHON ?= python
PIP ?= pip

.PHONY: install install-dev run test lint security reports clean docker-up docker-down

install:
	$(PIP) install -r requirements.txt

install-dev:
	$(PIP) install -r requirements-dev.txt

run:
	$(PYTHON) src/app.py

test:
	pytest -v --junitxml=reports/pytest-report.xml --cov=src --cov-report=xml:reports/coverage.xml --cov-report=html:htmlcov

lint:
	ruff check src tests

security:
	bandit -r src -f json -o reports/bandit-report.json
	pip-audit -r requirements.txt -f json -o reports/pip-audit-report.json

reports:
	mkdir -p reports

clean:
	rm -rf .pytest_cache .ruff_cache reports htmlcov

docker-up:
	docker compose up -d --build

docker-down:
	docker compose down
