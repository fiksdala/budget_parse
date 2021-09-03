# budget_parse
Tools for formatting copied Capital One transactions into tabular format


# What is this?

I built this little application to help with our household budget. We like to keep track of all credit card transactions, but the particulars of our budget make the usual budget software solutions not ideal. Instead, I created a google sheet for tracking expenses. However, Capital One makes it difficult to quickly download transactions from the current statement (including pending). You _can_ copy and paste transactions on the Capital One website using the "print" option, but the result is a single string of very unformatted text of all transacations (using the typical import options to make it tabular didn't work in this case). This application allows you to paste the unformatted output from Capital One and then retrieve a tabular version which plays nice with google sheets. A little overboard for a household budget? Perhaps. But it is effective. I doubt anybody aside from my wife and I will ever use this, but I'm keeping it public just for kicks.

# Usage

The application is available [here](https://afiks.shinyapps.io/CapitalOne_Formatting/). Instructions are simple and in the application. Basically you copy transactions from Capital One by choosing "Print", canceling the option, and then copy from the displayed pdf (do not copy headers). Then paste in the box in the application. A preview table will appear below, and below that you can copy the formatted text by pressing the "copy" button. 

# Future

This is a small, simple, and specific use case. I'll only update if Capital One changes formatting that requires adjustments to the parser. I have a local version of this code in python (not in this repo) that can format the changes from the command line. I may upload a variation of that to this repo as well at some point. 