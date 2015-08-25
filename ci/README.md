We use a couple pipelines for separation of concerns...

0. `dev` - this pipeline helps validate the quality of particular branches. It will monitor a particular branch for changes and, upon change, will run through all the appropriate tests. If they pass, the version file will be updated.
0. `release` - this pipeline helps create final releases. It will monitor a version file (typically from a `dev` pipeline) and can be manually triggered to create a new release.
0. `upgrades` - this pipeline will attempt to upgrade dependencies for automated testing. It will work off a given branch, attempt automatic upgrades, and push to another branch for further integration (typically another `dev` pipeline).

Versioning conventions...

0. Stable releases are >= `1.0.0` - we're only bumping major versions
0. Dev versions are `0.*`` and...
    1. Branches use `0.2.*+dev.*`
    1. Pull Requests use `0.1.*+dev.*`

When first settings things up, you may need to create artifacts...

    echo -n "0.2.0" > version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=develop/version --body=version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=develop/version-wip --body=version
    
    echo -n "0.1.0" > version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=pr/version --body=version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=pr/version-wip --body=version

    echo -n "22.0.0" > version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=release/version --body=version
    aws s3api put-object --bucket=logsearch-boshrelease-concoursetest --key=release/version-wip --body=version

Here are the short-term goals...

    develop  -> logsearch-develop -> develop/logsearch-(version).tgz -> develop/version
    branch      pipeline             s3                                 semver
    
    develop/version -> logsearch-release/major -> release/logsearch-(version).tgz -> release/version
    s3                 job manual trigger         s3                                 semver

    user/logsearch@bugfix-1 -> logsearch-pr123 -> pr/logsearch-(version).tgz
    branch                     pipeline           s3


If you'll be uploading stuff, be sure to put your credentials in `config/private-main.yml`. Override buckets for testing.

You might want to update your experimental concourse pipeline...

    $ fly configure \
      --config pipelines/concourse.yml \
      --vars-from config/default.yml \
      --vars-from config/private-main.yml \
      logsearch-boshrelease

You might want to serve your local repository while tweaking scripts...

    $ git daemon --base-path=../ -v --listen=172.23.240.4 --port=9191 --export-all
    $ echo 'git-master-uri: "git://172.23.240.4:9191/"' >> config/private-main.yml
