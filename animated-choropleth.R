rm(list=ls())
toInstall <- c("ggplot2", "maptools", "animation", "rgdal")
lapply(toInstall, library, character.only=TRUE)

# Load and clean WGI data
load('./data/wgi_cleaned.RData')

# Load world map shape file
world.map <- readOGR(dsn="./data", layer="TM_WORLD_BORDERS_SIMPL-0.3")
world.ggmap <- fortify(world.map, region = "NAME")

# Fix mismatched names
wgi$country[wgi$country=="Brunei"] <- "Brunei Darussalam"
wgi$country[wgi$country=="Laos"] <- "Lao People's Democratic Republic"
wgi$country[wgi$country=="North Korea"] <- "Korea, Democratic People's Republic of"
wgi$country[wgi$country=="South Korea"] <- "Korea, Republic of"
wgi$country[wgi$country=="Hong Kong Sar, China"] <- "Hong Kong"
wgi$country[wgi$country=="Iran"] <- "Iran (Islamic Republic of)"
wgi$country[wgi$country=="Libya"] <- "Libyan Arab Jamahiriya"
wgi$country[wgi$country=="Macedonia, Fyr"] <- "The former Yugoslav Republic of Macedonia"
wgi$country[wgi$country=="Russian Federation"] <- "Russia"
wgi$country[wgi$country=="St. Vincent and The Grenadines"] <- "Saint Vincent and the Grenadines"
wgi$country[wgi$country=="St. Lucia"] <- "Saint Lucia"
wgi$country[wgi$country=="Syria"] <- "Syrian Arab Republic"
wgi$country[wgi$country=="Netherlands Antilles (former)"] <- "Netherlands Antilles"
wgi$country[wgi$country=="Timor-leste"] <- "Timor-Leste"
wgi$country[wgi$country=="Taiwan, China"] <- "Taiwan"
wgi$country[wgi$country=="Micronesia, Fed. Sts."] <- "Micronesia, Federated States of"
wgi$country[wgi$country=="Congo, Dem. Rep."] <- "Democratic Republic of the Congo"
wgi$country[wgi$country=="Venezuela, Rb"] <- "Venezuela"
wgi$country[wgi$country=="Virgin Islands (u.s.)"] <- "United States Virgin Islands"
wgi$country[wgi$country=="Vietnam"] <- "Viet Nam"
wgi$country[wgi$country=="Guinea-bissau"] <- "Guinea-Bissau"
wgi$country[wgi$country=="Congo Republic"] <- "Congo"
wgi$country[wgi$country=="Côte D'ivoire"] <- "Cote d'Ivoire"  
wgi$country[wgi$country=="Myanmar"] <- "Burma"  
wgi$country[wgi$country=="São Tomé and Principe"] <- "Sao Tome and Principe"  
wgi$country[wgi$country=="Tanzania"] <- "United Republic of Tanzania" 
wgi$country[wgi$country=="West Bank and Gaza"] <- "Palestine"
wgi$country[wgi$country=="Moldova"] <- "Republic of Moldova"

# Plot
saveHTML({
  for (i in c(1996, 1998, 2000, 2002:2011)) {
    temp <- subset(na.omit(wgi[, c('year', 'country', 'cc_est')]), year==i)
    choro <- merge(world.ggmap, temp, by.x="id", by.y="country")
    choro <- choro[order(choro$order), ]
    p <- ggplot(data=choro, aes(long, lat, fill=cc_est, group=group))
    print(
      p + geom_polygon() + ylim(c(-60,85)) +
        scale_fill_gradient2("Control of\n corruption\n score", limits=c(-2.5,2.5)) + 
        labs(title=substitute(paste("Severity of corruption in the world, year ", i), list(i=i)))
    )
  }
}, ani.basename="world_corruption", interval=1,
         ani.width=900, ani.height=450,
         outdir=getwd())

saveLatex({
  for (i in c(1996, 1998, 2000, 2002:2011)) {
    temp <- subset(na.omit(wgi[, c('year', 'country', 'cc_est')]), year==i)
    choro <- merge(world.ggmap, temp, by.x="id", by.y="country")
    choro <- choro[order(choro$order), ]
    p <- ggplot(data=choro, aes(long, lat, fill=cc_est, group=group))
    print(
      p + geom_polygon() + ylim(c(-60,85)) +
        scale_fill_gradient2("Control of\n corruption\n score", limits=c(-2.5,2.5)) + 
        labs(title=substitute(paste("Severity of corruption in the world, year ", i), list(i=i)))
    )
  }
}, ani.basename = "world_corruption", interval=1,
          ani.width=900, ani.height=450,
          ani.opts="autoplay,loop,controls,width=\\linewidth",
          latex.filename = "world.corruption.tex",
          outdir=getwd())