# Cloudflare DDNS Updater Add-on for Home Assistant

An add-on for Home Assistant to automatically update your Cloudflare DNS record with your current public IP address.

## Features

- Automatically checks your public IP address.
- Updates your Cloudflare DNS record when your IP changes.
- Configurable update interval.

## Installation

1. Copy the git repo:
   ```
   https://github.com/sonpython/homeassistant-cloudflare-ddns.git
   ```

2. Go to the Home Assistant web interface, and navigate to **Settings** -> **Add-ons** -> **Add-on Store**.

3. Click on the **three dots** in the top right corner and select **Repositories**. Add the path to the add-on repository.

4. You should now see **Cloudflare DDNS Updater** in the list of available add-ons. Click on it and then click **Install**.

## Configuration

After installing, you need to configure the add-on. You can edit the configuration through the Home Assistant UI.

```yaml
cf_api_token: "YOUR_CLOUDFLARE_API_TOKEN"
zone_id: "YOUR_ZONE_ID"
record_name: "YOUR_RECORD_NAME"
update_interval: 300  # Time interval to check for IP changes (in seconds)
```

- **cf_api_token**: Your Cloudflare API token. Make sure it has the `Zone:DNS:Edit` permission.
- **zone_id**: The Zone ID for the domain you want to update.
- **record_name**: The DNS record you want to update, e.g., `example.com` or `subdomain.example.com`.
- **update_interval**: The time interval (in seconds) at which the add-on will check your public IP address and update Cloudflare if necessary.

## How to Get Cloudflare Credentials

### 1. Get `cf_api_token`

- Log in to [Cloudflare Dashboard](https://dash.cloudflare.com) and go to **My Profile** -> **API Tokens**.
- Click **Create Token** and select **Custom Token**.
- Set permissions: `Zone:DNS:Edit`.
- Create the token and save it somewhere secure.

### 2. Get `zone_id`

- Log in to [Cloudflare Dashboard](https://dash.cloudflare.com).
- Click on the domain you want to update.
- Scroll down to the **API** section, where you can find your **Zone ID**.

### 3. Set `record_name`

- This is the DNS record you want to update, e.g., `example.com` or `subdomain.example.com`.

## Usage

- Start the add-on after configuring it.
- The add-on will periodically check your public IP and update the DNS record in Cloudflare if your IP changes.

## Logs

You can see the logs of the add-on in the Home Assistant **Supervisor** -> **Cloudflare DDNS Updater** page to verify if the IP update was successful.

## Support

If you encounter any issues or have questions, please create an issue in this repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.s
