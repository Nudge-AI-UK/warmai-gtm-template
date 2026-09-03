# Warm AI template for Google Tag Manager

Loads the Warm AI tracker through GTM. Feature-identical to pasting the direct
script into your site's `<head>`.

## Install

This template is **not** in the Community Template Gallery. Import it by hand:

1. Download [`template.tpl`](template.tpl) from this repository.
2. In Google Tag Manager, go to **Templates** > **Template Gallery** panel >
   **New**, then the three-dot menu > **Import**.
3. Select the downloaded `template.tpl` and save.
4. Create a tag from the template, paste your **Tracking ID**, and set the
   trigger to **All Pages**. Fire it as early as you can.
5. Submit and publish the container.

Your Tracking ID is a UUID from your Warm AI dashboard, under **Websites**. It
is tied to one domain, subdomains included.

## What it does

The template injects your per-domain tracker:

```
https://cdn.menoinfra.com/p/<tracking id>.js
```

That file is assembled per customer at the edge, and the edge is where
company-level tracking and person-level identification are attached. So the
template only has to inject one URL, and a GTM install stays in step with a
direct install through any future change to what the tracker carries.

Everything else lives in the tracker: session handling, storage, SPA route
changes, and consent detection (Cookiebot, OneTrust, Transcend, CookieYes,
Klaro and GTM consent mode). There is nothing to configure here, and no second
consent check to add.

## Settings

| Setting | Required | Notes |
|---|---|---|
| Tracking ID | Yes | UUID from your dashboard |
| Script host | No | Only if Warm AI gave you a branded tracking host. You must also add that host to the template's *Injects Scripts* permission, or the tag will fail to fire. |

## Permissions

One: **Injects Scripts**, limited to `https://cdn.menoinfra.com/`.

The template reads and writes nothing in the browser. No cookies, no local
storage, no page content.

## Privacy and compliance

The tracker, not this template, determines what is collected and how consent is
handled. Those are documented in one place so they cannot drift:

- [Tracker privacy and compliance](https://docs.warmai.uk/legal/tracker)
- [Cookies and consent](https://docs.warmai.uk/guides/compliance)

Read those before going live, particularly if you serve EU, EEA or UK visitors.

## Upgrading from v1

v1 posted its own event payload to `track.getwarmai.com/api/gtm-track`. That
endpoint returns 404 and the tag records nothing, so a v1 install needs
replacing rather than leaving in place. Import v2, re-create the tag, and delete
the old one. See the changelog in `template.tpl` for detail.

## Support

- Install guide: https://docs.warmai.uk/guides/install
- Support: support@getwarmai.com

## Licence

Apache 2.0, see [LICENSE](LICENSE).
