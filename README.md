Intl Gum
==
##Corporate Info
International Gum was a small start up company founded by Kevin Andrew Hoiland and incorporated on August 16th 2010 in the State of California. International Gum Inc also did business under the name "Intl Gum". The company headquarters were in San Diego, CA.  The main domain name was www.intlgum.com and the toll free number was 1855-GUM-4YOU.

In November 2014, the company decided to shutdown and terminate the formal C corporation status. After Board and Shareholder approval, the company started closing all accounts and filing necessary paperwork. The Intl Gum website remained live and maintained as a free community site without payment processing and other overhead until June 2015 (at which point the site was shutdown and this repo made public).

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/homepage.png)

- - -

##User Experience
Intl Gum Membership was always free, which allowed usesrs to vote, rank, and comment on gum, along with other special privileges.  There were about 400 different gums cataloged for searching (for example via flavor), ranking, commenting, or just viewing various gum realted data points.  Non members still had access to the site for viewing gum info.

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/gumlist.png)

- - -

Intl Gum Members also had the option of paying $8 for a monthly subscription, which delivered a variety of gums directly to their door every month via mail.

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/billing_p3.png)

- - -

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/subscriptions.png)

- - -

Intl Gum created a new system for scoring gum:
* Gumtation: How tempting is the presentation, name, packaging, advertising, etc? 
* Chewlasticity: How is the size, texture, and flavor, both initially and over time? 
* Flavoracity: How accurate is the flavor? 
* Bubbability: How's the bubble blowing ability? 
* Gumalicious: How enjoyable and delicious is this gum?

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/gumrating.png)

- - -

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/ratingslist.png)

- - -

- - -
> ![Main Page](https://github.com/kevin-hoiland/ig/blob/master/doc/gumdetails.png)

- - -

##Site Backend
* Rails web stack with MySQL
* Imagemagick (uploading photos and auto full/icon size creations)
* User authorization, custom user accounts, and SMTP
* External integration with Amazon S3 for all gum images
* External integration with Authorize.Net for payment processing and monthly recurring billing
* External integration with Google AdSense, Adwords, and Analytics
* External integration with Amazon affiliate program
* Admin system for viewing user data, managing monthly subscription products, updating site content, and adding newly released gums
