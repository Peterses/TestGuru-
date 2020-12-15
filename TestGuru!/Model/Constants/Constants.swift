//
//  Constants.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 25/09/2020.
//

// TODO: -wrzucic constants do jednego folderu
struct Constants {
    // TODO: - rozbić "tematycznie" Constants
    static let appName = "TestGuru! 📝"

    // TODO: -struct SEGUES albo enum
    static let registerToAppSegue = "RegisterToApp"
    static let loginToAppSegue = "LoginToApp"
    static let showTestDetailSegue = "ShowTestDetail"
    static let searchTestSegue = "SearchTest"
    static let mainSegue = "MainViewSegue"
    static let afterTestSegue = "AfterTestSegue"
    static let showDuringTestSegue = "DuringTestSegue"
    static let showTestsByCategory = "showTestsByCategory"
    static let showMenu = "showMenu"
    static let editTestSegue = "EditTestSegue"
    static let showQuestionsSegue = "ShowQuestionsSegue"
    static let showMyTestInfo = "ShowMyTestInfo"
    static let addQuestionSegue = "AddQuestionSegue"
    static let showTestInfo = "showTestInfo"
    static let returnToQuestions = "returnToQuestions"
    
    // TODO: -rozbić
    static let reusableCell = "ReusableCell"
    static let categorieCell = "categorieCell"
    static let testCell = "TestCell"
    static let testsTitle = "Tests"
    
    // TODO: -rozbić i dać do DbManager?
    struct FStore {
        static let collectionTests = "tests"
        static let collectionQuestions = "questions"
        static let collectionCategories = "categories"
        static let collectionStats = "stats"
    }

    static let ok = "OK"
    
    static let goToApp = "Go To App"
    static let logout = "Logout"
    static let loginingOut = "Logging out"
    static let logoutQuestion = "Do you really want to logout?"
}
