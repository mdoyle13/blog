---
layout: post
title: Rails 7 CSP - How to add a nonce to an inline style tag (if you must)
subtitle: How I avoided using unsafe_inline and added a nonce to an inline style tag in Rails 7
date: 2022-07-22 00:00:00 -0000
---


I've been trying to get the Content Security Policy working in a new Rails 7 application but I have a `<style>` element in the document`<head>` that is causing problems when the CSP is enabled.

I don't want to add unsafe_inline to my CSP so the only other option is to use a nonce!

Unfortunately I need the styles to be "inline" because they are used to customize some CSS variables based on the logged in user's preferences and an inline style element with some ERB seemed like the quickest way to accomplish that

Here's how I ultimately got it working:

```ruby
content_tag(:style, nonce: content_security_policy_nonce) do
  ':root { --css-var: value; }'
end
```

The import part is the `content_security_policy_nonce` method (which just calls `request.content_security_policy_nonce`) will render the nonce in your ERB after the following two requirements are met

- You have `<%= csp_meta_tag %>` in your layout 
- You have something along these lines in your content security policy configuration

```ruby
config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
config.content_security_policy_nonce_directives = %w(script-src style-src)
```

See [https://edgeguides.rubyonrails.org/security.html#adding-a-nonce](https://edgeguides.rubyonrails.org/security.html#adding-a-nonce) for more info on configuring the nonce

The most important thing is to add `style-src` to the nonce directives. By default a new Rails project will only include script-src.

Rails does provide an easy way to do this with `<script>` tags but not with `<style>` tags - so here we are.

```ruby
<%= javascript_tag nonce: true do -%>
  alert('Hello, World!');
<% end -%>
```

I know its not good practice to have inline styles like this but this could be really helpful while adding CSP to a legacy app or when you really need to have the styles inline/in the head.


