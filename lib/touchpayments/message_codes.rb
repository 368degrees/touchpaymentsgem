module TouchPayments
  module MessageCodes	
    
     ERR_INTERNAL                               = -32000.freeze
     ERR_VALIDATION                             = -32001.freeze
     ERR_ORDER_NOT_FOUND                        = -32002.freeze
     ERR_AUTHENTICATION_FAILURE                 = -32003.freeze
     ERR_ITEM_WRONG_FORMAT                      = -32004.freeze
     ERR_NO_MULTIPLE_ITEMS                      = -32005.freeze
     ERR_WRONG_SMS_CODE                         = -32006.freeze
     ERR_INVALID_ADDRESS                        = -32007.freeze
     ERR_INVALID_CHARACTERS                     = -32008.freeze
     ERR_INVALID_POSTCODE_SUBURB_COMBINATION    = -32009.freeze
     ERR_DEVICE_SCORE_TOO_LOW                   = -32010.freeze
     ERR_CUSTOMER_DETAILS_MISSING               = -32011.freeze
     ERR_ARTICLES_CANNOT_BE_UPDATED             = -32012.freeze
     ERR_VALIDATION_MSG                              = "Validation Error".freeze
     ERR_ORDER_NOT_FOUND_MSG                         = "Order could not be found".freeze
     ERR_AUTHENTICATION_FAILURE_MSG                  = "Authentication failure".freeze
     ERR_ITEM_WRONG_FORMAT_MSG                       = "Order Items have the wrong format".freeze
     ERR_NO_MULTIPLE_ITEMS_MSG                       = "Multiple items not supported".freeze
     ERR_WRONG_SMS_CODE_MSG                          = "Wrong sms code provided".freeze
     ERR_INVALID_ADDRESS_MSG                         = "Invalid Address provided".freeze
     ERR_INVALID_CHARACTERS_MSG                      = "Invalid Characters used eg < or >".freeze
     ERR_INVALID_POSTCODE_SUBURB_COMBINATION_MSG     = "Invalid Postcode and suburb Combination provided.".freeze
     ERR_DEVICE_SCORE_TOO_LOW_MSG                    = "Given device is not trustworthy.".freeze
     ERR_INTERNAL_MSG                                = "Internal error".freeze
  end

end
