# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).
This changelog is generated automatically based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## [0.5.1](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.5.0...v0.5.1) (2024-08-02)


### Bug Fixes

* disable gradual rollout ([#112](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/112)) ([6adc018](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/6adc01845cf2bd98ae440c15fae5fef62138a90d))

## [0.5.0](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.4.0...v0.5.0) (2024-06-24)


### Features

* Implement new Ops agent policy module ([#101](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/101)) ([a6598c3](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/a6598c363ae6d446e732c9cf4762143ce16165a3))

## [0.4.0](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.3.0...v0.4.0) (2023-11-09)


### Features

* upgraded versions.tf to include minor bumps from tpg v5 ([0d5f47c](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/0d5f47c90180932170c3e8ce8d3240ecfb56dfea))

## [0.3.0](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.2.4...v0.3.0) (2023-06-21)


### Features

* adding a simple uptime check sub-module ([#67](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/67)) ([202afef](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/202afeff2562199bf65cc0fc92d18345a7edad99))

## [0.2.4](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.2.3...v0.2.4) (2022-12-30)


### Bug Fixes

* create uuid as a resource to save value between runs ([#58](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/58)) ([2f0fed3](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/2f0fed3a9e7ddad239f9ce8f817bfa2cab75acb3))
* fixes lint issues and generates metadata ([#56](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/56)) ([e369bfb](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/e369bfb736494815eefe059e111aeec51f1a5f2c))


### [0.2.3](https://github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.2.2...v0.2.3) (2022-02-08)


### Bug Fixes

* Use python3 explicitly and clean up python commands in script-utils.sh. ([#36](https://github.com/terraform-google-modules/terraform-google-cloud-operations/issues/36)) ([a1dcdb4](https://github.com/terraform-google-modules/terraform-google-cloud-operations/commit/a1dcdb46b4f6c090579085c521e9820a68907cf3))

### [0.2.2](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.2.1...v0.2.2) (2021-10-15)


### Bug Fixes

* remove dependency on realpath for mac ([#23](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/23)) ([c69c4ec](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/c69c4ecb54d4cfa8757fc50456388b45802e9e40))
* Support Python 3 ([#27](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/27)) ([04094aa](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/04094aaa1502f760ecbded9f451cc0099aad8c31))
* use relative paths in gcloud scripts ([#32](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/32)) ([8f0b303](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/8f0b303840ee59aaca9b14c63b6ea272be920881))

### [0.2.1](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.2.0...v0.2.1) (2021-03-30)


### Bug Fixes

* Fixing the swapped descriptiion ([#18](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/18)) ([4ea8c76](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/4ea8c768f95bcd052cb7cbf8ef820a3339565767))
* Update documentation to support ops-agent as a new agent type ([#16](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/16)) ([bbdce0d](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/bbdce0d6e76d1054098b8862e98eccf08db254e5))

## [0.2.0](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.1.1...v0.2.0) (2021-02-03)


### Features

* Promote alpha to beta ([#11](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/11)) ([478e152](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/478e152aaa91be105e5df227f4cab7a6461c7ec5))

### [0.1.1](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/compare/v0.1.0...v0.1.1) (2020-10-07)


### Bug Fixes

* Use full URL to fix broken links in the rendered Terraform doc. ([#9](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/9)) ([8c5dd63](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/8c5dd633289935c045687fa7d5974d29ccb8680e))

## 0.1.0 (2020-09-11)


### Features

* Initial release of agent policy module ([#2](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/issues/2)) ([1649ec8](https://www.github.com/terraform-google-modules/terraform-google-cloud-operations/commit/1649ec88d2cd9985da3d3b4f709551f5d540fb5a))
