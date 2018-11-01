# Bulk merger

Bulk merge Pull Requests from Dependabot.

## Setup

Add your token with repo access to `.env`:

```
export GITHUB_TOKEN=<yourtoken>
```

The scripts will use this token to talk to GitHub.

## Bulk approve PRs

```
./review gds-api-adapters
```

This looks for unreviewed Dependabot PRs in `alphagov` with "gds-api-adapters" in the title. If it finds any, it will list them out and ask you to confirm if you want to approve them.

Use this command for third-party libraries that need [a second GOV.UK reviewer](https://docs.publishing.service.gov.uk/manual/manage-ruby-dependencies.html#who-can-merge-dependabot-prs).

```shell
@tijmenb ~/govuk/bulk-merger on master $ ./review gds-api-adapters
Searching for Dependabot PRs for gem 'gds-api-adapters'
Found 3 unreviewed PRs:

- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/short-url-manager/pull/262)
- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/local-links-manager/pull/328)
- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/email-alert-service/pull/205)

Have you reviewed the changes, and you want to approve all these PRs? [y/N]
y
OK! Approving away...
Reviewing PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/short-url-manager/pull/262) ✅
Reviewing PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/local-links-manager/pull/328) ✅
Reviewing PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/email-alert-service/pull/205) ✅
```

## Approve & merge all Pull Requests

```
./merge govuk_publishing_components
```

This will run the `./review` script above, but also merge the approved PRs.

Use this command for gems that are owned by GOV.UK [and can be merged without a second reviewer](https://docs.publishing.service.gov.uk/manual/manage-ruby-dependencies.html#who-can-merge-dependabot-prs).

Because all repos have [branch protection turned on](https://docs.publishing.service.gov.uk/manual/configure-github-repo.html), you won't be able to merge PRs that haven't passed on CI.

```sh
Found 4 reviewed but unmerged PRs:

- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/short-url-manager/pull/262)
- 'Bump gds-api-adapters from 53.1.0 to 54.0.0' (https://github.com/alphagov/frontend/pull/1658)
- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/local-links-manager/pull/328)
- 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/email-alert-service/pull/205)

Have you reviewed the changes, and you want to MERGE all these PRs? [y/N]
y
OK! Approving away...
Merging PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/short-url-manager/pull/262) ❌ Failed to merge: "PUT https://api.github.com/repos/alphagov/short-url-manager/pulls/262/merge: 405 - Required status check \"continuous-integration/jenkins/branch\" is errored. // See: https://help.github.com/articles/about-protected-branches"
Merging PR 'Bump gds-api-adapters from 53.1.0 to 54.0.0' (https://github.com/alphagov/frontend/pull/1658) ❌ Failed to merge: "PUT https://api.github.com/repos/alphagov/frontend/pulls/1658/merge: 405 - 2 of 2 required status checks have not succeeded: 1 expected and 1 pending. // See: https://help.github.com/articles/about-protected-branches"
Merging PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/local-links-manager/pull/328) ✅
Merging PR 'Bump gds-api-adapters from 53.2.0 to 54.0.0' (https://github.com/alphagov/email-alert-service/pull/205) ✅
```

## Licence

[MIT License](LICENSE)
