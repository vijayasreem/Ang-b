
trigger UserAuthenticationTrigger on User (before insert, before update) {
    // Step 1: Check if the user is logging in
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        List<User> usersToAuthenticate = new List<User>();
        
        for (User user : Trigger.new) {
            // Step 2: Check if the user's credentials are valid
            if (user.Username != null && user.Password__c != null) {
                User storedUser = [SELECT Id, Username, Password__c, Role__c FROM User WHERE Username = :user.Username LIMIT 1];
                
                if (storedUser != null && storedUser.Password__c == user.Password__c) {
                    // Step 3: Log in the user and direct them to their dashboard
                    user.LastLoginDate = DateTime.now();
                    usersToAuthenticate.add(user);
                } else {
                    // Step 4: Display an error message and allow the user to retry
                    user.addError('Invalid username or password');
                }
            }
        }
        
        // Step 5: Update the user records to log in the users
        update usersToAuthenticate;
    }
}

trigger UserAuthorizationTrigger on User (before insert, before update) {
    // Step 7: Check the user's role and permissions
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        for (User user : Trigger.new) {
            if (user.Role__c == 'Admin') {
                // Allow access to all areas and actions
            } else if (user.Role__c == 'Manager') {
                // Allow access to specific areas and actions for managers
            } else {
                // Step 8: Prevent unauthorized users from accessing restricted areas or performing actions beyond their permissions
                user.addError('Unauthorized access');
            }
        }
    }
}
