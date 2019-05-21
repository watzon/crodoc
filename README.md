# crodoc - crystal's op documenter

crodoc is a documentation tool for the Crystal programming language meant to be a replacement for the built in documenter. The goal of crodoc is to be a more powerful and extensible way to document your code, with support for [meta-data tags](#meta-data-tags), [plugins](#plugins), [custom templates](#custom-templates), and more.

# Features

## Meta-data Tags

Meta-data tags are used to add arbitrary meta-data about a documented object. These tags simply add data to objects that can be looked up later, and potentially displayed. The nice thing about meta-data tags is that they allow you to organize your comments easily and systematically, and allow exporters to easily glean important information about your code. Let's look at an code example using Crystal's documenter:

```crystal
# Example from watzon/octokit.cr

# Check if you is following a user. Alternatively check if a given user
# is following a target user.
#
# **Examples:**
# ```
# @client.follows?("asterite")
# @client.follows?("asterite", "waj")
# ```
#
# **Note:** Requires an authenticated user.
#
# **See Also:**
# - [https://developer.github.com/v3/...](https://developer.github.com/v3/...)
# - [https://developer.github.com/v3/...](https://developer.github.com/v3/...)
def follows?(user, target = nil)
  ...
end
```

Because the Crystal documenter only supports markdown I had to manually create sections for Examples, Notes, and See Also. Crystal does have limited support for certain items like NOTE, DEPRECATED, etc. but there aren't many options. Now let's looks at a (proposed) example for crodoc.

```crystal
# Check if you is following a user. Alternatively check if a given user
# is following a target user.
#
# @note Requires an authenticated user.
# @see https://developer.github.com/v3/users/followers/#check-if-you-are-following-a-user]
# @see https://developer.github.com/v3/users/followers/#check-if-one-user-follows-another
# @example
#   @client.follows?("asterite")
#   @client.follows?("asterite", "waj")
def follows?(user, target = nil)
  ...
end
```

Not only is it 7 less lines, It's also easier to type and easier to parse. Meta-data tags can do just about anything as well.

## Plugins

With plugins crodoc becomes so much more than just a documentation generator. Plugins can do things like add meta-data tags, generators, parsers, etc.

## Custom Templates

Currently there is only one available way to view your Crystal documentation, and (objectively) it isn't great. Personally I don't like being locked into a specific style of doing things. As such with crodoc you can choose a custom template with which to render your documentation. This is an option that YARD provides, and the Crystal community deserves it too.

## Installation

You can install crodoc in three ways:

#### Using CURL

To install with CURL (the easiest method) run the following in your terminal:

```shell
curl -L https://git.io/fj4sg | bash
```

and let it install. If you wish to inspect the installer script just check it out [here](https://github.com/watzon/crodoc/blob/master/install.sh).

#### Clone the Repo

You can always build this from sources. The installer does this anyway if a binary isn't avaialable for your system.

```shell
git clone https://github.com/watzon/crodoc.git
cd crodoc
crystal build ./src/crodoc.cr --release
```

When building from sources you will have to manually move the binary so that it's on your path.

#### Add to Your Project

You can also add crodoc locally to your project. Doing this will build a binary in the root of your project, allowing you to run it with `./crodoc`.

```yaml
# shard.yml

development_dependencies:
  crodoc:
    github: watzon/crodoc
```

Don't forget to run `shards install` after adding it to your `shard.yml`.

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it (<https://github.com/watzon/crodoc/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
