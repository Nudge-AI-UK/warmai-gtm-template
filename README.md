# Warm AI - Website Visitor Analytics Template for Google Tag Manager

Track website visitors and their engagement to identify your most engaged B2B prospects.

## Features

- **Page View Tracking**: Capture every page visit with full URL and referrer data
- **Session Management**: Automatic session handling with configurable timeout
- **Scroll Depth Tracking**: Monitor how far visitors scroll (0-100%)
- **Duration Tracking**: Track time spent on each page
- **Privacy-First**: No PII collection, GDPR-compliant design

## Installation

### From Google Tag Manager Template Gallery

1. In Google Tag Manager, go to **Templates** > **Search Gallery**
2. Search for "Warm AI"
3. Click **Add to workspace**
4. Create a new tag using the Warm AI template

### Manual Installation

1. Download `template.tpl` from this repository
2. In Google Tag Manager, go to **Templates** > **New**
3. Click the three-dot menu > **Import**
4. Select the downloaded `template.tpl` file
5. Save the template

## Configuration

### Required Settings

| Setting | Description |
|---------|-------------|
| **Tracking ID** | Your Warm AI Tracking ID (found in Dashboard > Settings > Tracking Code) |
| **Event Type** | Select "Page View" for most triggers |

### Optional Settings

| Setting | Default | Description |
|---------|---------|-------------|
| **Track Scroll Depth** | Enabled | Monitor scroll percentage |
| **Track Page Duration** | Enabled | Track time on page |
| **Session Timeout** | 30 min | Inactivity timeout before new session |
| **Custom Endpoint** | - | Override default tracking URL |

## Recommended Trigger Setup

### All Page Views
Create a trigger:
- **Trigger Type**: Page View
- **This trigger fires on**: All Page Views

### Single Page Applications (SPA)
For React, Vue, Angular apps, also create:
- **Trigger Type**: History Change
- **This trigger fires on**: All History Changes

## Data Collected

| Parameter | Description |
|-----------|-------------|
| `tid` | Your Tracking ID |
| `et` | Event type (page_view, session_start) |
| `st` | Session token |
| `url` | Full page URL |
| `path` | Page path |
| `host` | Domain name |
| `ref` | Referrer URL |
| `ts` | Timestamp |
| `sd` | Scroll depth (0-100) |
| `dur` | Page duration (seconds) |

## Privacy & Compliance

- No personally identifiable information (PII) is collected
- Session tokens are randomly generated, not fingerprints
- All data is transmitted securely via HTTPS
- Compatible with cookie consent management platforms
- GDPR and CCPA compliant

## Support

- **Documentation**: https://docs.getwarmai.com/tracking/gtm
- **Support**: support@getwarmai.com
- **Website**: https://www.getwarmai.com

## License

Apache License 2.0 - see [LICENSE](LICENSE) file for details.
