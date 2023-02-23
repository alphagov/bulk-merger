# Bulk merger

Bulk merge Pull Requests for MoJ repos.

Forked and modified from [alphagov/bulk-merger](https://github.com/alphagov/bulk-merger)

## Setup

Create a "Personal access token", with at least the `repo/public_repo`
scope. Ensure this PAT has SSO authorisation for the `ministryofjustice` organisation. Add your token with repo access to `.env`:

```
export GITHUB_TOKEN=<yourtoken>
```

The scripts will use this token to talk to GitHub.

## Bulk approve PRs

```
./review modernisation-platform actions/checkout
```

This looks for unreviewed PRs in repos containing `modernisation-platform` with "actions/checkout" in the title. If it finds any, it will list them out and ask you to confirm if you want to approve them.


```shell
$./review modernisation-platform checkov-action
Searching for PRs containing 'checkov-action' in repositories whose name contains modernisation-platform
Found 1 unreviewed PRs:

- 'Bump bridgecrewio/checkov-action from 12.2150.0 to 12.2151.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-module-template/pull/49) 

Have you reviewed the changes, and you want to approve all these PRs? [y/N]
y
OK! 👍 Approving away...
Reviewing PR 'Bump bridgecrewio/checkov-action from 12.2150.0 to 12.2151.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-module-template/pull/49) ✅
```

## Approve & merge all Pull Requests

```
./merge modernisation-platform actions/checkout
```

This will run the `./review` script above, but also merge the approved PRs.

Because all repos have [branch protection turned on](https://docs.publishing.service.gov.uk/manual/configure-github-repo.html), you won't be able to merge PRs that haven't passed on CI.

```sh
Searching for PRs containing 'checkov-action' in repositories whose name contains modernisation-platform
No unreviewed PRs found!
Found 3 reviewed but unmerged PRs:

- 'Bump bridgecrewio/checkov-action from 12.2150.0 to 12.2151.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-module-template/pull/49) 
- 'Bump bridgecrewio/checkov-action from 12.2138.0 to 12.2150.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-loadbalancer/pull/47) 
- 'Bump bridgecrewio/checkov-action from 12.2138.0 to 12.2149.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-cross-account-access/pull/39) 

Have you reviewed the changes, and you want to MERGE all these PRs? [y/N]
y
OK! 👍 Merging away...
Merging PR 'Bump bridgecrewio/checkov-action from 12.2150.0 to 12.2151.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-module-template/pull/49) ✅
Merging PR 'Bump bridgecrewio/checkov-action from 12.2138.0 to 12.2150.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-loadbalancer/pull/47) ❌ Failed to merge: "PUT https://api.github.com/repos/ministryofjustice/modernisation-platform-terraform-loadbalancer/pulls/47/merge: 405 - Required status check \"Run Go Unit Tests\" is failing. // See: https://docs.github.com/articles/about-protected-branches"
Merging PR 'Bump bridgecrewio/checkov-action from 12.2138.0 to 12.2149.0' (https://github.com/ministryofjustice/modernisation-platform-terraform-cross-account-access/pull/39) ✅
```

## Licence

[MIT License](LICENCE)
