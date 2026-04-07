function __take_is_archive_url --argument-names url
    switch $url
        case 'http://*' 'https://*' 'ftp://*'
            set -l no_query (string split -m1 '?' -- $url)[1]
            switch $no_query
                case '*.tar.bz2' '*.tar.gz' '*.tar.xz' '*.zip' '*.rar' '*.bz2' '*.gz' '*.tar' '*.tbz2' '*.tgz' '*.Z' '*.7z' '*.xz' '*.exe'
                    return 0
            end
    end

    return 1
end

function __take_is_git_url --argument-names url
    switch $url
        case '*.git' '*.git/'
            switch $url
                case 'http://*' 'https://*' 'git://*' 'ssh://*' 'ftp://*' 'ftps://*' 'rsync://*' '*@*:*' '*+@*'
                    return 0
            end
    end

    return 1
end

function mkcd -d "Create a directory and cd into it"
    command mkdir -p $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                pwd -P
                return 0
        end
    end
end

function takegit --description 'Clone a git repo and cd into it'
    if test (count $argv) -eq 0
        echo 'Usage: takegit <repo-url>' >&2
        return 1
    end

    git clone $argv[1]; or return 1

    set -l repo_path (string replace -r '/$' '' -- $argv[1])
    set -l repo_name (basename -- $repo_path)
    set repo_name (string replace -r '\\.git$' '' -- $repo_name)

    cd -- $repo_name; or return 1
    pwd -P
end

function takeurl --description 'Download archive URL, extract it, and cd into result directory'
    if test (count $argv) -eq 0
        echo 'Usage: takeurl <url>' >&2
        return 1
    end

    command -q extract
    or begin
        echo 'takeurl: extract command not found in PATH' >&2
        return 1
    end

    set -l url_no_query (string split -m1 '?' -- $argv[1])[1]
    set url_no_query (string split -m1 '#' -- $url_no_query)[1]
    set -l filename (string split -r -m1 '/' -- $url_no_query)[-1]

    if test -z "$filename" -o "$filename" = /
        echo 'takeurl: URL must include an archive filename with extension' >&2
        return 1
    end

    if not string match -q '*.*' -- $filename
        echo 'takeurl: URL must include an archive filename with extension' >&2
        return 1
    end

    set -l tmpbase /tmp
    if set -q TMPDIR; and test -n "$TMPDIR"
        set tmpbase $TMPDIR
    end

    set -l tmpdir (mktemp -d "$tmpbase/takeurl.XXXXXXXX"); or return 1
    set -l data "$tmpdir/$filename"

    curl -fL $argv[1] -o "$data"
    if test $status -ne 0
        rm -rf -- "$tmpdir"
        return 1
    end

    set -l result_path (extract "$data")
    set -l extract_status $status
    rm -rf -- "$tmpdir"

    if test $extract_status -ne 0
        return $extract_status
    end

    if test -n "$result_path"
        printf '%s\n' "$result_path"
    end

    if test -d "$result_path"
        cd -- "$result_path"; or return 1
    end
end

function take --description 'Create directory or clone/extract URL, then cd'
    if test (count $argv) -eq 0
        echo 'Usage: take <dir|repo-url|archive-url>' >&2
        return 1
    end

    if __take_is_archive_url $argv[1]
        takeurl $argv[1]
    else if __take_is_git_url $argv[1]
        takegit $argv[1]
    else
        mkcd $argv
    end
end
