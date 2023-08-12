.PHONY: debug
debug: lint
	swift build --arch arm64

.PHONY: lint
lint:
	swiftlint --strict --quiet

.PHONY: test
test:
	swift test | xcbeautify

.PHONY: spelling
spelling:
	.github/scripts/checkSpell.sh
