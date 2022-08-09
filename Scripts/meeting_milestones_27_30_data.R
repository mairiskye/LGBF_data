library(phsopendata)
library(magrittr)
library(dplyr)

meetingDevMilestonesDatasetID <- "018ba0e1-6562-43bb-82c5-97b6c6cc22d8"
meetingDevMilestonesData <- phsopendata::get_resource(meetingDevMilestonesDatasetID) %>%
  select(CA, FinancialYear, NumberOfEligibleChildren, NoConcerns, NoConcernsNotAllValid) %>%
  mutate(PercentMeetingMilestones = NoConcerns + NoConcernsNotAllValid/NumberOfEligibleChildren) %>%
  filter(CA != "RA2704") #this line filters 'Other Residential Categories (i.e. council not specified)
