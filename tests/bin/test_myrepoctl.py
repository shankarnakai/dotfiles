"""Unit tests for bin/myrepoctl — pure URL-building functions across forges.

Run from the repo root:  pytest tests/bin/test_myrepoctl.py
The script has no .py extension, so it is loaded by path via importlib.
"""

import importlib.util
import os
from importlib.machinery import SourceFileLoader
from pathlib import Path

import pytest

_SCRIPT = Path(__file__).resolve().parents[2] / "bin" / "myrepoctl"
_loader = SourceFileLoader("myrepoctl", str(_SCRIPT))
_spec = importlib.util.spec_from_loader("myrepoctl", _loader)
myrepoctl = importlib.util.module_from_spec(_spec)
_loader.exec_module(myrepoctl)


# --- parse_remote -----------------------------------------------------------

@pytest.mark.parametrize("url, expected", [
    ("git@github.com:org/repo.git", ("github.com", "org/repo")),
    ("git@github.com:org/repo", ("github.com", "org/repo")),
    ("https://github.com/org/repo.git", ("github.com", "org/repo")),
    ("https://github.com/org/repo", ("github.com", "org/repo")),
    ("https://user@bitbucket.org/team/repo.git", ("bitbucket.org", "team/repo")),
    ("ssh://git@gitlab.com:22/group/sub/repo.git", ("gitlab.com", "group/sub/repo")),
    ("git@github-work:work-org/repo.git", ("github-work", "work-org/repo")),
])
def test_parse_remote(url, expected):
    assert myrepoctl.parse_remote(url) == expected


def test_parse_remote_invalid():
    with pytest.raises(ValueError):
        myrepoctl.parse_remote("not a url")


# --- normalize_host & detect_forge ------------------------------------------

def test_normalize_host_alias():
    assert myrepoctl.normalize_host("github-work") == "github.com"


def test_normalize_host_passthrough():
    assert myrepoctl.normalize_host("gitlab.com") == "gitlab.com"


@pytest.mark.parametrize("host, forge", [
    ("github.com", "github"),
    ("bitbucket.org", "bitbucket"),
    ("gitlab.com", "gitlab"),
])
def test_detect_forge(host, forge):
    assert myrepoctl.detect_forge(host) == forge


def test_detect_forge_unknown():
    with pytest.raises(ValueError):
        myrepoctl.detect_forge("example.com")


# --- build_url: the full forge × action matrix ------------------------------

GITHUB = "git@github.com:org/repo.git"
BITBUCKET = "https://bitbucket.org/team/repo.git"
GITLAB = "git@gitlab.com:group/repo.git"
GITHUB_WORK = "git@github-work:work-org/repo.git"


@pytest.mark.parametrize("remote, kind, kwargs, expected", [
    # url / repo (forge-independent)
    (GITHUB, "url", {}, "https://github.com/org/repo"),
    (GITHUB, "repo", {}, "https://github.com/org/repo"),
    (GITHUB_WORK, "url", {}, "https://github.com/work-org/repo"),

    # pull/merge request list
    (GITHUB, "pr", {}, "https://github.com/org/repo/pulls"),
    (BITBUCKET, "pr", {}, "https://bitbucket.org/team/repo/pull-requests/"),
    (GITLAB, "pr", {}, "https://gitlab.com/group/repo/-/merge_requests"),

    # create PR/MR
    (GITHUB, "create-pr", {}, "https://github.com/org/repo/compare"),
    (BITBUCKET, "create-pr", {}, "https://bitbucket.org/team/repo/pull-requests/new"),
    (GITLAB, "create-pr", {}, "https://gitlab.com/group/repo/-/merge_requests/new"),

    # commit
    (GITHUB, "commit", {"sha": "abc123"}, "https://github.com/org/repo/commit/abc123"),
    (BITBUCKET, "commit", {"sha": "abc123"}, "https://bitbucket.org/team/repo/commits/abc123"),
    (GITLAB, "commit", {"sha": "abc123"}, "https://gitlab.com/group/repo/-/commit/abc123"),

    # file at a branch
    (GITHUB, "file", {"branch": "main", "path": "src/a.py"},
     "https://github.com/org/repo/blob/main/src/a.py"),
    (BITBUCKET, "file", {"branch": "main", "path": "src/a.py"},
     "https://bitbucket.org/team/repo/src/main/src/a.py"),
    (GITLAB, "file", {"branch": "main", "path": "src/a.py"},
     "https://gitlab.com/group/repo/-/blob/main/src/a.py"),
])
def test_build_url(remote, kind, kwargs, expected):
    assert myrepoctl.build_url(remote, kind, **kwargs) == expected


# --- repo_relative_path: $GIT_PREFIX handling -------------------------------
# Git runs `!`-aliases from the repo root and exposes the caller's original
# subdirectory in $GIT_PREFIX. Mock _git to return cwd so the result depends
# only on GIT_PREFIX + the given path.

def test_repo_relative_path_honors_git_prefix(monkeypatch, tmp_path):
    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(myrepoctl, "_git", lambda *a: os.getcwd())
    monkeypatch.setenv("GIT_PREFIX", "roles/git/")
    assert myrepoctl.repo_relative_path("templates/x.j2") == "roles/git/templates/x.j2"


def test_repo_relative_path_no_prefix(monkeypatch, tmp_path):
    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(myrepoctl, "_git", lambda *a: os.getcwd())
    monkeypatch.delenv("GIT_PREFIX", raising=False)
    assert myrepoctl.repo_relative_path("a/b.py") == "a/b.py"
