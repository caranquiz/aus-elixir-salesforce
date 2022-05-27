declare module "@salesforce/apex/CustomerPortalUserController.isPasswordExpired" {
  export default function isPasswordExpired(): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.getUserEmail" {
  export default function getUserEmail(): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.changePassword" {
  export default function changePassword(param: {password: any, confirmPassword: any, oldPassword: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.getCommunityBaseUrl" {
  export default function getCommunityBaseUrl(): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.getPasswordPolicy" {
  export default function getPasswordPolicy(): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.forgotPassword" {
  export default function forgotPassword(param: {username: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.getSecurityQuestionInfo" {
  export default function getSecurityQuestionInfo(): Promise<any>;
}
declare module "@salesforce/apex/CustomerPortalUserController.changePasswordStrongAuth" {
  export default function changePasswordStrongAuth(param: {password: any, confirmPassword: any, oldPassword: any, securityQuestionAnswer: any}): Promise<any>;
}
