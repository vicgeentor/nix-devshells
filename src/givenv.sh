#!/usr/bin/env sh

input=$1
template_dir=@template_dir@
templates=($(ls $template_dir))

template_found=false
for template in "${templates[@]}"; do
  if [[ $template == $input ]]; then
    template_found=true
    break
  fi
done

if ! $template_found; then
  echo "\"$input\" is not a valid template choice"
  exit
fi

if [ -f ./.envrc ]; then
  echo ".envrc already found. Moving existing .envrc to .envrc.bak."
  mv .envrc .envrc.bak
fi
cp "$template_dir"/"$template"/.envrc .

if [ -f ./flake.nix ]; then
  echo "flake.nix already found. Moving existing flake.nix to flake.nix.bak"
  mv flake.nix flake.nix.bak
fi
cp "$template_dir"/"$template"/flake.nix .

if [ -f ./flake.lock ]; then
  echo "flake.lock already found. Moving existing flake.lock to flake.lock.bak"
  mv flake.lock flake.lock.bak
fi
cp "$template_dir"/"$template"/flake.lock .

if [ -f ./.gitignore ]; then
  echo ".gitignore already found. Not making any changes to it"
else
  cp "$template_dir"/"$template"/.gitignore .
fi

if [[ $input == "haskell" ]]; then
  # Check if any .cabal file already exists
  if ! ls ./*.cabal >/dev/null 2>&1; then
    # Try to create a sensible name
    if [ -n "$input" ] && [ -d "$template_dir/$input" ]; then
      # Most common patterns: use directory name or look for project-name.cabal in template
      cabal_template="$template_dir/$input/project.cabal"
      if [ -f "$cabal_template" ]; then
        # Try to guess project name from current directory
        proj_name=$(basename "$(pwd)")
        if [ -z "$proj_name" ] || [ "$proj_name" = "/" ]; then
          proj_name="my-project"
        fi

        target_cabal="$proj_name.cabal"
        cp "$cabal_template" "./$target_cabal"
        echo "Created $target_cabal"
      else
        echo "Warning: project.cabal not found in template directory"
      fi
    fi
  else
    echo ".cabal file already found. Not making any changes to it"
  fi
fi

chmod +w *
chmod +w .*
