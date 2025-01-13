
# Meta --------------------------------------------------------------------

## Title:  Dartmouth Atlas Data
## Author: Ian McCarthy
## Date Created: 10/15/2019
## Date Edited:  1/4/2022


# Preliminaries -----------------------------------------------------------

## Read in data
for (t in 2003:2015) {
  mort.data <- read_xls(here(paste("data/",t,"_mortality_hrr.xls",sep="")),
                        col_names=c("HRR","HRR Name","Enrollees",
                                    "Total_Mortality","NonHMO_Mortality"),
                        skip=1)
  mort.data <- mort.data %>%
    mutate(Year=t)
  assign(paste("mort.",t,sep=""),mort.data)
}
mort.data <- rbind(mort.2003, mort.2004, mort.2005, mort.2006, mort.2007, mort.2008,
                   mort.2009, mort.2010, mort.2011, mort.2012, mort.2013, mort.2014,
                   mort.2015)
exp.data <- read_csv(here("data/Atlas_Reimbursements_2003-2015.csv"))

# Tidy --------------------------------------------------------------------

exp.data <- pivot_longer(exp.data, cols=starts_with("Y"),
                         names_to="Year", names_prefix="Y",
                         values_to="Expenditures")
exp.data <- exp.data %>%
  rename(HRR=HRR_ID) %>%
  select(HRR, Year, Expenditures) %>%
  mutate(Year=as.integer(Year))

dartmouth.data <- exp.data %>%
  left_join(mort.data, by=c("HRR","Year")) %>%
  filter(complete.cases(.))
