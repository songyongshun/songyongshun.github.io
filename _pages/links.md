---
layout: archive
title: "Links"
permalink: /links/
author_profile: true
---

{% include base_path %}

常用站点导航

<table>
  <thead>
    <tr>
      <th>名称</th>
      <th>说明</th>
    </tr>
  </thead>
  <tbody>
    {% for link in site.data.navigation.links %}
    <tr>
      <td><a href="{{ link.url }}">{{ link.name }}</a></td>
      <td>{{ link.desc | default: "" }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
