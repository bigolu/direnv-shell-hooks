# For this to work correctly, this file must be loaded before direnv's config
# runs. This way, we can wrap `__direnv_export_eval` before it gets a chance to
# run. To give this config a better chance of running first, we add a "_" to the
# beginning of the file name. This helps since fish sorts files by name before
# running them.

if not status is-interactive
    exit
end

# Replace direnv's prompt hook with one that will call our pre and post hooks.
function _dsh_load_direnv_hook_wrapper --on-event fish_prompt
    # This should only run once
    functions --erase (status current-function)

    if not type --query __direnv_export_eval
        return
    end

    functions --copy __direnv_export_eval __direnv_export_eval_backup

    function __direnv_export_eval --on-event fish_prompt
        set -l did_direct_move (_dsh_did_direct_move)
        set -l nearest_envrc "$(_dsh_nearest_envrc)"
        # TODO: Actually checking this would be too slow since we have to run
        # direnv for each file on the watch list.
        set -l did_watched_file_change false

        if test $did_direct_move = true
            # t_cd_to_a_different_direnv
            _dsh_run_unload_hook
        else if test -z "$nearest_envrc"
            and set --query DIRENV_DIR

            # t_cd_outside_direnv
            set --erase _dsh_direnv_loaded
            _dsh_run_unload_hook
        else if test $did_watched_file_change = true
            # t_change_watched_file, t_block, t_allow
            _dsh_run_unload_hook
        end

        __direnv_export_eval_backup

        if not set --query --global _dsh_direnv_loaded
            and set --query DIRENV_DIR

            # t_cd_to_direnv, t_subshell, t_exec
            set --global _dsh_direnv_loaded true
            _dsh_run_load_hook
        else if test $did_direct_move = true
            # t_cd_to_a_different_direnv
            _dsh_run_load_hook
        else if test $did_watched_file_change = true
            # t_change_watched_file, t_block, t_allow
            _dsh_run_load_hook
        end
    end

    __direnv_export_eval
end

function _dsh_run_load_hook
    if set --export --query DIRENV_HOOK_LOAD_fish
        eval "$DIRENV_HOOK_LOAD_fish"
    end
end

function _dsh_run_unload_hook
    if set --export --query DIRENV_HOOK_UNLOAD_fish
        eval "$DIRENV_HOOK_UNLOAD_fish"
    end
end

function _dsh_nearest_envrc
    set -l current_directory (pwd)
    while true
        if test -e $current_directory/.envrc
            echo $current_directory/.envrc
            return
        end

        set -l parent_directory $current_directory/..
        # This will happen when we hit the root directory e.g. '/'
        if test $current_directory -ef $parent_directory
            return
        end
        set current_directory $parent_directory
    end
end

# Prints 'true' if we moved from one direnv directly to another
function _dsh_did_direct_move
    if not set --query DIRENV_DIR
        echo false
        return
    end

    set -l nearest_envrc "$(_dsh_nearest_envrc)"
    if test -z "$nearest_envrc"
        echo false
        return
    end

    # DIRENV_DIR starts with a '-', the `string sub` removes it
    set -l direnv_dir (string sub --start 2 -- $DIRENV_DIR)
    if test (path resolve (path dirname $nearest_envrc)) != (path resolve $direnv_dir)
        echo true
        return
    end

    echo false
end

function _dsh_did_watched_file_change
    set -l watched_files (direnv watch-print --null | string split0)
    for file in $watched_files
        if not direnv current $file >/dev/null 2>&1
            echo true
            return
        end
    end

    echo false
end
