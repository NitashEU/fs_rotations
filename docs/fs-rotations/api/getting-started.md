# Getting Started

In this document, you will learn how to setup and begin playing with Sylvanas. It's a very simple procedure, but we will try to explain everything thoroughfully.

## Welcome Letter

First of all, thanks for choosing Sylvanas. We know that our unique approach might be scary at first and appreciate those adventurers who deposit their trust on us. We have invested a lot of time and passion in this project and we want to make it as close to perfection as possible. Of course, we know that this is a long way, but with your feedback we are confident we will get there very soon, since we have all the tools required for it. You are also welcome to become a Lua developer here with us! Check [Getting Started - Developers](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/getting-started-dev>)
Without further ado, let's begin playing with Sylvanas 🫶
note

- Supported OS: Windows 10 1909 to Windows 11 24h2
- Suported DX version: 12 (In WoW Settings, navitage to System -> Graphics -> Graphics API -> Set to DirectX 12)

## Step 1: Register on the Website[​](https://docs.project-sylvanas.net/docs/<#step-1-register-on-the-website> "Direct link to Step 1: Register on the Website")

Head over to our official [website](https://docs.project-sylvanas.net/docs/<https:/project-sylvanas.net>) and create an account to gain access to the Sylvanas project. To create an account, press the login button and in the new page, press Create Account:

- Press the Login button ![](https://downloads.project-sylvanas.net/1730369419966-sylvanas_1_loginbutton.png)
- Press the "Register Now!" button ![](https://downloads.project-sylvanas.net/1730369571653-register_button.png)
- Finally, just enter your new username and password, verify the captcha and click the Register button.

## Step 2: Purchase Gold[​](https://docs.project-sylvanas.net/docs/<#step-2-purchase-gold> "Direct link to Step 2: Purchase Gold")

To fully enjoy the Sylvanas experience, you need to acquire **Gold** – our in-game currency that unlocks subscriptions and additional features. There are two ways to purchase Gold:

### 1. Direct Purchase with Cryptocurrency[​](https://docs.project-sylvanas.net/docs/<#1-direct-purchase-with-cryptocurrency> "Direct link to 1. Direct Purchase with Cryptocurrency")

- **Payment Methods:** BTC & LTC
- **How It Works:** Visit our official website’s Gold Purchase section and choose your preferred crypto payment method. Once your BTC or LTC payment is confirmed, your account will be automatically credited with Gold.

### 2. Purchase via Authorized Resellers[​](https://docs.project-sylvanas.net/docs/<#2-purchase-via-authorized-resellers> "Direct link to 2. Purchase via Authorized Resellers")

If you prefer using other payment methods (such as PayPal or Credit Card), you can purchase Gold through our trusted resellers. You will receive a redeem code upon purchase which you can then apply to your account.

#### Mew – PayPal[​](https://docs.project-sylvanas.net/docs/<#mew--paypal> "Direct link to Mew – PayPal")

- **How to Purchase:** Open a ticket on our server and tag **@mew_am**. Mention that you wish to purchase via PayPal, and Mew will provide you with all the necessary payment instructions.

#### Travers – PayPal/Crypto – Automated Shop[​](https://docs.project-sylvanas.net/docs/<#travers--paypalcrypto--automated-shop> "Direct link to Travers – PayPal/Crypto – Automated Shop")

- **How to Purchase:** Visit his . Fill in your Discord ID and email address. After completing the purchase:
  - If you paid via PayPal, your redeem code will be sent to your **PayPal email**.
  - If you used another payment method, the code will be delivered to the email you provided.

#### Redeeming Your Gold[​](https://docs.project-sylvanas.net/docs/<#redeeming-your-gold> "Direct link to Redeeming Your Gold")

Once you have your redeem code from a reseller:

1. Go to [Redeem Gold](https://docs.project-sylvanas.net/docs/<https:/project-sylvanas.net/panel/shop/coins>).
2. Enter your code to credit your account – typically, the most common package is **30,000 Gold** , which covers a 1-month subscription.
3. Finally, visit [Subscriptions](https://docs.project-sylvanas.net/docs/<https:/project-sylvanas.net/panel/shop/subscription>) to select the subscription period that suits you best.

note
If you encounter any issues during the purchasing process, feel free to open a ticket on our Discord server for support.

## Step 3: Subscribe to Plugins[​](https://docs.project-sylvanas.net/docs/<#step-3-subscribe-to-plugins> "Direct link to Step 3: Subscribe to Plugins")

1. Visit the [Plugin Management Page](https://docs.project-sylvanas.net/docs/<https:/project-sylvanas.net/panel/user/plugins>) on our website. This is located within the **User Panel** under the **Plugins** tab.
2. Browse through the list of available plugins. You can search for plugins specific to the class you want to play or other functionalities you are interested in.
3. Click the **Subscribe** button next to the plugins you want to use.

### Important Notes[​](https://docs.project-sylvanas.net/docs/<#important-notes> "Direct link to Important Notes")

- Subscriptions are applied **only when you inject the loader** or when you manually refresh them using the **top-left refresh button** in the in-game menu.
- If you make any changes to your subscriptions on the website, they will not take effect automatically. You must either restart the game and re-inject the loader or use the **refresh button** for the changes to be applied seamlessly without restarting.

## Step 4: Download and Run the Loader[​](https://docs.project-sylvanas.net/docs/<#step-4-download-and-run-the-loader> "Direct link to Step 4: Download and Run the Loader")

Afer you logged in, you’ll now see a download button in the top right corner. Choose between the US and CN loaders based on your game region. ![](https://downloads.project-sylvanas.net/1730370275402-loaderdownload.png)
Download the loader and execute it in the location where you want your Sylvanas files to be stored. The loader will automatically download and generate necessary files, including scripts and other resources.
note
Create a folder to store the loader, don't throw it on the Desktop, and open it from there directly because all the files like the Lua scripts that the loader will automatically download will be spread throughout your Desktop. (It's not like you are not allowed to do this, it's just a recommendation)

## Step 5: Open the Loader[​](https://docs.project-sylvanas.net/docs/<#step-5-open-the-loader> "Direct link to Step 5: Open the Loader")

When you run the loader for the first time, one of two things may happen:

- The loader opens smoothly, and you’re ready to play.
- An error message appears. In that case, please refer to [this page for troubleshooting](https://docs.project-sylvanas.net/docs/<https:/docs.project-sylvanas.net/docs/common-issues>). If your issue isn’t listed, feel free to open a Discord ticket for additional help.

If everything went correctly, you should see a "Login" and "Password" input texts. You have to use the same credentials you are using for the webpage, and then click the "Login" button. After that, you will see the "Inject" button
note
You will see that you can choose the version that you are trying to inject. Usually, the one that is selected is the good to go for default, but check out for possible updates in Discord or messages sent by the Staff in this regard. Some versions will have "CN" in their description. As you imagined, these versions are ONLY for CN (China) customers. If nothing is specified, you can assume it's an EU version.

## Step 6: Injecting and Playing[​](https://docs.project-sylvanas.net/docs/<#step-6-injecting-and-playing> "Direct link to Step 6: Injecting and Playing")

Once the loader opens successfully (either immediately or after troubleshooting), you’re ready to inject!
tip
Injection can be done with Battle.net closed or while the game is running, even mid-dungeon. There is no difference in security or ban risk either way.

## Step 7 (Optional): Join the Discord Server[​](https://docs.project-sylvanas.net/docs/<#step-7-optional-join-the-discord-server> "Direct link to Step 7 (Optional): Join the Discord Server")

Once registered:

- Join our Discord server. To do so, just click on the Discord icon on the top-right navbar of the webpage: ![](https://downloads.project-sylvanas.net/1730369877095-discords.png)

note
No questions, prerequisites, or requirements are needed to access the platform! It’s completely free and straightforward, with no temporary trials

- Open a ticket if you find any issue: ![](https://downloads.project-sylvanas.net/1730369998715-tickets.png)

## In-Game Controls[​](https://docs.project-sylvanas.net/docs/<#in-game-controls> "Direct link to In-Game Controls")

When in-game, you can manage Sylvanas with these keys:

- Press `F6` to reload scripts.
- Use `INSERT` to open and close the main menu.
- Use `DELETE` to open and close the console.

note
The console also has a handy "Copy All" button—great for sending Lua error logs to us via Discord tickets or direct messages. ![](https://downloads.project-sylvanas.net/1730371073763-copyallconsole.png)

## Enjoy playing!

We hope you enjoy Sylvanas as much as we enjoy working on it!
tip
Continue reading the following user pages for tips and tricks to learn and configure Sylvanas faster 🕺
[[menu-user]]

- [Overview](https://docs.project-sylvanas.net/docs/<#overview>)
- [Step 1: Register on the Website](https://docs.project-sylvanas.net/docs/<#step-1-register-on-the-website>)
- [Step 2: Purchase Gold](https://docs.project-sylvanas.net/docs/<#step-2-purchase-gold>)
  - [1. Direct Purchase with Cryptocurrency](https://docs.project-sylvanas.net/docs/<#1-direct-purchase-with-cryptocurrency>)
  - [2. Purchase via Authorized Resellers](https://docs.project-sylvanas.net/docs/<#2-purchase-via-authorized-resellers>)
- [Step 3: Subscribe to Plugins](https://docs.project-sylvanas.net/docs/<#step-3-subscribe-to-plugins>)
  - [Important Notes](https://docs.project-sylvanas.net/docs/<#important-notes>)
- [Step 4: Download and Run the Loader](https://docs.project-sylvanas.net/docs/<#step-4-download-and-run-the-loader>)
- [Step 5: Open the Loader](https://docs.project-sylvanas.net/docs/<#step-5-open-the-loader>)
- [Step 6: Injecting and Playing](https://docs.project-sylvanas.net/docs/<#step-6-injecting-and-playing>)
- [Step 7 (Optional): Join the Discord Server](https://docs.project-sylvanas.net/docs/<#step-7-optional-join-the-discord-server>)
- [In-Game Controls](https://docs.project-sylvanas.net/docs/<#in-game-controls>)
