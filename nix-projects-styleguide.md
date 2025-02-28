# Nix Project Style Guide

This guide establishes a conversational yet structured approach to commenting Nix code. It applies to all Nix-related files in this repository, including NixOS configurations, nix-darwin setups, flakes, and custom modules.

## Comment Structure

Each major code section should be introduced with a block comment that answers three key questions in a conversational tone:

The "what" of the thing - Describing what this piece of code represents or defines
The thing it "does" - Explaining what actions or functionality this code provides
The "why" of the thing - Clarifying the purpose or reasoning behind this code

***IMPORTANT*** 

**DO NOT ACTUALLY WRITE THE WORDS "What", "Does" & "Why" WHEN COMMENTING CODE. IT'S MERELY PROVIDED AS A REFERENCE. E.G. - [THIS IS A NOTE, NOT A COMMENT]**

For example:

```nix
# This is our main system configuration flake.nix file
#
# It supplies a unified configuration for both MacOS and NixOS
# systems, so that they can be expressed declaritely (a fancy way
# to say "as static files"), along with making their necessary 
# dependencies to make builds reproducible (identical and 
# functional regardless of the machine its run on)
#
# It's amazingly convenient once setup, and our current file here
# sets up our complete development environment, including:
#
#       - Package management through nix and homebrew
#       - User environments via home-manager
#       - System services and security settings
#
# Flakes are also much easier to maintain, but require more initial 
# to initially configure. That being said, what follows is the genesis 
# of every nix flake.
# Begin by providing the description at the top of a flake.nix file like so

description = "Starter Configuration with secrets for MacOS and NixOS";  # The text inside the quotes names this flake for identification to us and others.
```

## Guidelines for Writing Comments

1. Use a conversational tone while maintaining clarity
2. Keep each line under 80 characters for readability
3. Group related concepts together
4. Add visual spacing between unrelated sections
5. Use indentation to show relationship between comments

## Comment Types

### Block Comments (Above Code)
- Start with a friendly introduction
- Follow with What/Does/Why structure
- Add any relevant context or gotchas
- Example:

```nix
# Here's how we manage our development shell, the place where
# almost all software in the world is forged. 
#
# It wil contain our development environment, so that all our 
# essential tools right there when we need them. 
# It basically ensures everyone on the team 
# has the same development experience.
devShell = {
  # ... code ...
};
```

### Inline Comments
- Keep them brief but clear
- Explain non-obvious choices
- Use a conversational tone
- Example:

```nix
allowUnfree = true;  # We need this for some of our design tools
```

### Alternative Settings
- Show other common options
- Explain when to use them
- Example:

```nix
nodejs = "20";  # Current LTS version for our projects
# nodejs = "18";  # Use this if you need older package compatibility
```

## Real-World Example

```nix
# This example is our core package configuration
# Configurations like these provide a main package 
# list by allowing us to spawn our favorite tools
# as we work. Things like;
#
#       - Development tools (git, node, python)
#       - Security tools (gpg, ssh)
#       - Quality of life improvements (fzf, ripgrep)
#
# We want a consistent set of tools across all our machines,
# and this makes it easier to pair program and troubleshoot
{
  environment.systemPackages = with pkgs; [
    git          # Essential for version control
    nodejs_20    # Current LTS for our projects
    python311    # Latest stable Python
    
    # Security tools we rely on
    gnupg        # For signing commits
    openssh      # Remote access
    
    # Quality of life improvements
    fzf          # Makes searching so much nicer
    ripgrep      # Better than grep for code search
  ];
}
```

## Why This Approach Works

- Makes documentation feel like a conversation with future maintainers
- Provides clear structure while remaining approachable
- Helps new team members understand not just what the code does, but why we wrote it this way
- Makes future modifications easier by explaining our reasoning

Remember: Good comments tell a story about your code, making it easier for others (and future you) to understand and maintain it.