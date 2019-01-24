#DS710 Final Project - Shawn Chapler
#Read in cleansed csv file & attach data
TwitterData=read.csv('C:/Users/smc/Documents/GitHub/ds710summer2017finalproject/twitter_df_full_clean.csv', header=TRUE, strip.white = TRUE, 
                     colClasses=c("character", "numeric", "character", "character", "integer", "character", "integer", "character",
                                  "integer", "character", "character", "numeric", "character", "integer", "character", "character", "character"))
attach(TwitterData)

#view data loaded into R vector & summarize each variable
#[1] 1809   17
dim(TwitterData)

#View samples of the data
head(TwitterData)
summary(TwitterData)

#Review Rows for missing values in retweet_count and favorite_count
summary(TwitterData$favorite_count)
summary(TwitterData$retweet_count)
summary(TwitterData$hashtag_count)

#Review Rows with no hashtags for formatting issues.  They will get dropped in the gg2plots automatically.
# length = 15
#[1]   25   30   92  275  305  413  415  416  507  555 1001 1027 1446
#[14] 1512 1680
#No formatting issues in these rows
noHT <-which(TwitterData$hashtag_count == 0)
length(noHT)
noHT

#Ensure no duplicate rows
#[1] 1809
length(unique(TwitterData$id))


#count rows by retweet value - bot values suspected
#retweet_count count
#1              0  1457
#2              1    77
#3              2    20
#4              3     9
#5              4     6
#6              6     1
#7              7     9
#8             10    11
#9             13    10
#10           105     1
#11           149   136
#12           229    72

aggregate(cbind(count = id) ~ retweet_count, 
          data = TwitterData, 
          FUN = function(x){NROW(x)})

#Create second dataframe and drop rows suspected of bot activity. 
#Only rows with retweet activity less than 100 included.
TD2 = subset(TwitterData, retweet_count < 100)

#count rows by retweet value on new dataframe excluding retweets above 100
aggregate(cbind(count = id) ~ retweet_count, 
          data = TD2, 
          FUN = function(x){NROW(x)})


#Plot Data - Call ggplot2 for pretty graphs
#Scatterplot of retweet_count as function of hashtag count 
#Compare plots of Full Data Set Against Plots of Suspected Bot Activity Removed Sets
require(ggplot2)


p1=qplot(hashtag_count, retweet_count, data=TwitterData, geom = c("point", "smooth"), method="lm", se = FALSE, colour = stitchfix_boolean, main='Figure 1: Retweet Count by Hashtag Count - Full',  xlab= "Hash Tag Count", ylab="Retweet Count", xlim=c(1,10)) + labs(colour = "StitchFix Tags")
p2=qplot(hashtag_count, retweet_count, data=TD2, geom = c("point", "smooth"), method="lm", se = FALSE, colour = stitchfix_boolean, main='Figure 3: Retweet Count by Hashtag Count - No Outliers',  xlab= "Hash Tag Count", ylab="Retweet Count", xlim=c(1,10)) + labs(colour = "StitchFix Tags")

p3=qplot(hashtag_count, favorite_count, data=TwitterData, geom = c("point", "smooth"), method="lm", se = FALSE, colour = stitchfix_boolean, main='Figure 2: Favorite Count by Hashtag Count - Full', xlab= "Hash Tag Count", ylab="Favorite Count", xlim=c(1,10)) + labs(colour = "StitchFix Tags")
p4=qplot(hashtag_count, favorite_count, data=TD2, geom = c("point", "smooth"), method="lm", se = FALSE, colour = stitchfix_boolean, main='Figure 4: Favorite Count by Hashtag Count - No Outliers', xlab= "Hash Tag Count", ylab="Favorite Count", xlim=c(1,10)) + labs(colour = "StitchFix Tags")

#Multiplot Function at bottom of R Code for ease in reading the study. Must be run before generating plots
multiplot(p1, p2, p3, p4, cols=2)



#Increasing variation to the right implies need for log tranformation on y
#apply log transformation 
#Error does not allow for log of 0/inf
logRetweetCount=log(TD2$retweet_count)
logRetweetCount
model1b=lm(logRetweetCount~TD2$hashtag_count, na.action=na.omit)




#Histogram preparing for t-test
par( mfrow = c( 1, 2 ))
hist(TwitterData$hashtag_count, main="Histogram of Hashtag Count - Full", xlab="Hashtag Count")

#Histogram preparing for t-test
hist(TD2$hashtag_count, main="Histogram of Hashtag Count - No Outliers", xlab="Hashtag Count") 

#Applying the log to the data did not smooth the data.  The data was more of a multi-modal pattern with peaks at 1 and 3 or 4 hashtags depending on the dataset. 
#Opted to use actuals for analysis for this reason.
loghashtag_count=log(TD2$hashtag_count)
hist(loghashtag_count)
loghashtag_count=log(TD2$hashtag_count)
hist(loghashtag_count)

#The null and alternative hypothesis of the means of two groups
#H0 : u0 = u1
#Ha: u0 != u1
#H0:  The mean number of hashtags for stitchfix twitters is the same than that of non-stitchfix twitters.
#H1:  The mean number of hashtags for stitchfix twitters is not the same of that of non-stitchfix twitters.


#t test - Full
t.test(TwitterData$hashtag_count ~ TwitterData$stitchfix_boolean, alternative = "two.sided")

#Welch Two Sample t-test
#
#data:  TwitterData$hashtag_count by TwitterData$stitchfix_boolean
#t = -26.427, df = 796.85, p-value < 2.2e-16
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  -1.943788 -1.674990
#sample estimates:
#  mean in group False  mean in group True 
#1.379256            3.188645 

#Check Counts of Stitchfix vs NonStitch Fix tags
#True = [1] 546
#False= [1] 1263
length(which(TwitterData$stitchfix_boolean=='True'))
length(which(TwitterData$stitchfix_boolean== 'False'))

#Comparative T-Test on StellaDot.  StellaDot hashtags drove a large portion of the twitter activity.

t.test(TwitterData$hashtag_count ~ TwitterData$stelladot_boolean, alternative = "two.sided")
#Welch Two Sample t-test
#
#data:  TwitterData$hashtag_count by TwitterData$stelladot_boolean
#t = 25.371, df = 929.96, p-value < 2.2e-16
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  1.53397 1.79118
#sample estimates:
#  mean in group False  mean in group True 
#2.939093            1.276519 

#Check Counts of Stelladot versus Non-Stelladot row counts
#True = [1] 1103
#False= [1] 706
length(which(TwitterData$stelladot_boolean=='True'))
length(which(TwitterData$stelladot_boolean== 'False'))

#t test - Outliers Removed for comparison purposes for StitchFix
t.test(TD2$hashtag_count ~ TD2$stitchfix_boolean, alternative = "two.sided")

#Welch Two Sample t-test
#
#data:  TD2$hashtag_count by TD2$stitchfix_boolean
#t = -13.898, df = 409.13, p-value < 2.2e-16
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  -1.501125 -1.129087
#sample estimates:
#  mean in group False  mean in group True 
#1.379256            2.694362 

#Check Counts of StitchFix versus Non-StitchFix row counts
#True = [1] 337
#False= [1] 1263
length(which(TD2$stitchfix_boolean=='True'))
length(which(TD2$stitchfix_boolean== 'False'))

#t test - Outliers Removed for comparison purposes for Stelladot

t.test(TD2$hashtag_count ~ TD2$stelladot_boolean, alternative = "two.sided")

#Welch Two Sample t-test
#
#data:  TD2$hashtag_count by TD2$stelladot_boolean
#t = 14.914, df = 592.63, p-value < 2.2e-16
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  1.061486 1.383464
#sample estimates:
#  mean in group False  mean in group True 
#2.498994            1.276519 

#Check Counts of Stelladot versus Non-Stelladot row counts
#True = [1] 1103
#False= [1] 497

length(which(TD2$stelladot_boolean=='True'))
length(which(TD2$stelladot_boolean== 'False'))

#count rows by hashtag count in the dataframe with outliers removed
#hashtag_count count
#1              0    15
#2              1  1116
#3              2   158
#4              3   174
#5              4    63
#6              5    37
#7              6    20
#8              7     7
#9              8     2
#10             9     6
#11            10     2

aggregate(cbind(count = id) ~ hashtag_count, 
          data = TD2, 
          FUN = function(x){NROW(x)})

#create table of hashtag count vs retweet count.  Shows how much bot like traffic is driving retweet counts.
#hashtag_count
#0   1   2   3   4   5   6   7   8   9  10 
#2  94 152  74 136  19   0   0   0   0   0 
xtabs(retweet_count~hashtag_count, data=TD2)

#hashtag_count
#0     1     2     3     4     5     6     7     8     9    10 
#2   199   152    74 36888    19     0     0     0     0     0 
xtabs(retweet_count~hashtag_count, data=TwitterData)

#create table of hashtag count vs favorite count.  Shows how little bot like traffic influence favorite counts.
#hashtag_count
#0   1   2   3   4   5   6   7   8   9  10 
#17 152  77  52  22  27   8   3   2   1   1 
xtabs(favorite_count~hashtag_count, data=TD2)

#hashtag_count
#0   1   2   3   4   5   6   7   8   9  10 
#17 152  77  52  44  27   8   3   2   1   1 
xtabs(favorite_count~hashtag_count, data=TwitterData)

#Explore Hashtag count of 4 which has significant impact on retweet value
TD4 = subset(TwitterData, hashtag_count==4)
 
#count rows by hashtag count
#retweet_count count
#1             0    41
#2             1     7
#3             2     6
#4            13     9
#5           149   136
#6           229    72
Aggregate(cbind(count = id) ~ retweet_count, 
          data = TD4, 
          FUN = function(x){NROW(x)})

#Review counts of StitchFix vs. Non-StitchFix Tweets - 90% 
#True=[1] 245
#False=[1] 26
length(which(TD4$stitchfix_boolean=='True'))
length(which(TD4$stitchfix_boolean== 'False'))

#Review counts of StellaDot vs. Non-StellaDot Tweets
#True=[1] 16
#False=[1] 255
length(which(TD4$stelladot_boolean=='True'))
length(which(TD4$stelladot_boolean== 'False'))

#Review Data Related to the two outlier categories 
TD4_229 = subset(TD4, retweet_count==229)
TD4_149 = subset(TD4, retweet_count==149)

#Identify users for assessment on Twitter.com - Interesting 
TD4_229$user_screen_name

#[1] "LifeWithKathy"   "CassidySpringf2" "SBellasWays"    
#[4] "morewless"       "BloggyBarbie"    "FountainOf30"   
#[7] "krazykatfreebie" "mommyhoodLife"   "owen_author"    
#[10] "sayhellonature"  "ABlissfulNest"   "Couponmamacita" 
#[13] "Whoneedsacape"   "DJayJp"          "SlickHousewives"
#[16] "tasalinas"       "hhtfamilyblog"   "KnottyMarie"    
#[19] "intheknowmom"    "CMarieNico"      "GiveawayBandit" 
#[22] "Makebestcrafts"  "MilWivesSaving"  "elenka29"       
#[25] "ColorSutraa"     "2kidsandacoupon" "philZENdia"     
#[28] "PinkNinjaBlogg"  "guidednyc"       "SweetNSourDeals"
#[31] "vrstardiaries"   "somedaypicks"    "candielee41"    
#[34] "FunMoneyMom"     "OldHousetoHome"  "julieredshoes"  
#[37] "smilingnote"     "MomGlenz"        "ThatMamaG"      
#[40] "QueenThrifty"    "hmiblog"         "stillblondeaaty"
#[43] "DisneyDream717"  "NotQuiteSusie"   "EmilyReviewsCom"
#[46] "SunshineFlipFl"  "TheTipToeFairy"  "foodyschmoody"  
#[49] "EricasWalk"      "SunnySweetDays"  "smartshopperv"  
#[52] "Lovesmytwoboys"  "jsismee"         "KimsCravings"   
#[55] "bellyrulesdmind" "EngineerMomBlog" "_maintainingme" 
#[58] "genofsavings"    "SavvySavingCoup" "lifesouthernmom"
#[61] "KimiJClark"      "LauraT_Funk"     "thiswortheylife"
#[64] "PPlates"         "FoundFrolicking" "cookwith5kids"  
#[67] "MidgetMomma1200" "gdblogsite"      "MomSpotted"     
#[70] "365DaysofBaking" "ThriftyDIYDiva"  "Pp7E8yS6ENSt4xU"


# Multiple plot function - 
# From http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}