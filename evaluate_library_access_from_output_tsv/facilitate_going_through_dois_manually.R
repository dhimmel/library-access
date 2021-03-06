facilitate_going_through_dois <- function(
  manual_tsv_location = file.path(
    'evaluate_library_access_from_output_tsv',
    'manual-doi-checks-500.tsv'
  )){
  # Open the tsv -----------------------------------------------------------------
  
  dataset_to_go_through <- readr::read_tsv(
    manual_tsv_location,
    na = ''
  )
  # View(dataset_to_go_through)
  
  # Facilitate going through the rows that haven't been filled in ----------------
  
  while (TRUE) {
    user_location_input <- readline(paste0(
      'Are you on the university campus network',
      '(y for on-campus, n for off-campus)? [y/n]'
    ))
    
    if (
      tolower(user_location_input) == 'y' ||
      tolower(user_location_input) == 'n'
    ) {
      if (tolower(user_location_input) == 'y') {
        column_for_data_entry <- 'penn_access'
        column_for_date <- 'penn_access_date'
      } else {
        column_for_data_entry <- 'open_access'
        column_for_date <- 'open_access_date'
      }
      
      break  # Break out of the loop, and move on.
    } else {
      message('Please enter y or n. Asking again...')
    }
  }
  
  for (row_number in which(
    is.na(dataset_to_go_through[, column_for_data_entry])
  )) {
    doi_for_row <- dataset_to_go_through[row_number, 'doi']
    
    url_to_visit <- paste0(
      'https://doi.org/',
      doi_for_row
    )
    
    message('Opening URL "', url_to_visit, '"...')
    
    utils::browseURL(url_to_visit)
    
    while (TRUE) {
      user_full_text_input <- readline(
        'Do we have full-text access to this DOI? [y/n/invalid]
        ("invalid" = invalid DOI)'
      )
      
      if (
        tolower(user_full_text_input) == 'y' ||
        tolower(user_full_text_input) == 'n' ||
        tolower(user_full_text_input) == 'invalid'
      ) {
        dataset_to_go_through[
          row_number,
          column_for_date
          ] <- as.character(Sys.Date())
        
        if (tolower(user_full_text_input) == 'y') {
          dataset_to_go_through[row_number, column_for_data_entry] <- 1
        } else if (tolower(user_full_text_input) == 'n') {
          dataset_to_go_through[row_number, column_for_data_entry] <- 0
        } else {
          dataset_to_go_through[row_number, column_for_data_entry] <- 'invalid'
        }
        
        break  # Break out of the loop, and move on.
      } else {
        message('Please enter y, n, or invalid. Asking again...')
      }
    }
    
    # Save the changes to the tsv:
    readr::write_tsv(
      dataset_to_go_through,
      manual_tsv_location,
      na = ''
    )
  }
}

facilitate_going_through_dois()
