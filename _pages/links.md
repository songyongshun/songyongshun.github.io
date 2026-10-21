---
layout: archive
title: "Links"
permalink: /links/
author_profile: true
---

{% include base_path %}

常用站点导航，按分类整理。

{% assign cat_names = site.data.links.categories | map: "title" %}
{% for cat in cat_names %}[{{ cat }}](#{{ cat | slugify }}){% unless forloop.last %} · {% endunless %}{% endfor %}

{% for category in site.data.links.categories %}
<h2 id="{{ category.title | slugify }}">{{ category.title }}</h2>

<table>
  <thead>
    <tr>
      <th>名称</th>
      <th>说明</th>
    </tr>
  </thead>
  <tbody>
    {% for link in category.links %}
    <tr>
      <td><a href="{{ link.url }}" target="_blank" rel="noopener">{{ link.name }}</a></td>
      <td>{{ link.desc | default: "" }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
{% endfor %}
