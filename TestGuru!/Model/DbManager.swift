//
//  DbManager.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 06/10/2020.
//

import Foundation
import Firebase
import CodableFirebase

final class DbManager {

    static let shared = DbManager()
    private final let db = Firestore.firestore()
    
    private init() { }
    
    // MARK: - CategoryOperations
    public func saveCategory(category: CategoryModel, completion: @escaping (Bool) -> Void) {
        guard let docData = try? FirestoreEncoder().encode(category) else {
            return
        }
        db.collection(Constants.FStore.collectionCategories).addDocument(data: docData) { (error) in
            if let error = error {
                print("Dev: \(error.localizedDescription)")
                completion(false)
                fatalError()
            } else {
                completion(true)
            }
        }
    }
    
    public func getAllTests(completion: @escaping ([TestModel]?, Bool?) -> Void) {
        db.collection(Constants.FStore.collectionTests).getDocuments { (doc, isSuccess) in
            guard let doc = doc else {
                return
            }
            var tests: [TestModel] = []
            for document in doc.documents {
                if let model = try? FirebaseDecoder().decode(TestModel.self, from: document.data()) {
                    let test = model
                    tests.append(test)
                } else {
                    print("DEV: no data, sorry :-(")
                    completion(nil, false)
                }
            }
            completion(tests, true)
        }
    }
    
    public func getAllCategories(completion: @escaping ([CategoryModel]?, Bool?) -> Void) {
        var categories: [CategoryModel] = []
        db.collection(Constants.FStore.collectionCategories)
            .getDocuments { (docData, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    completion(nil, false)
                } else {
                    guard let doc = docData else {
                        return
                    }
                    for document in doc.documents {
                        if let model = try? FirebaseDecoder().decode(CategoryModel.self, from: document.data()) {
                            let category = model
                            categories.append(category)
                        } else {
                            print("DEV: no data, sorry :-(")
                        }
                    }
                }
                completion(categories, true)
            }
    }
    
    public func getCategoryByName(name: String, completion: @escaping (CategoryModel?, Bool) -> Void) {
        db.collection(Constants.FStore.collectionCategories).whereField("name", isEqualTo: name)
            .getDocuments { (docData, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    completion(nil, false)
                } else {
                    guard let doc = docData else {
                        print("error")
                        return
                    }
                    
                    var category: CategoryModel?
                    
                    for document in doc.documents {
                        if let model = try? FirebaseDecoder().decode(CategoryModel.self, from: document.data()) {
                            category = model
                        } else {
                            print("DEV: no data, sorry :-(")
                        }
                    }
                    completion(category, true)
                }
            }
    }
    
    public func getPopularTests(limit: Int, completion: @escaping ([TestModel]?, Bool) -> Void) {
        db.collection(Constants.FStore.collectionTests).order(by: "popularity", descending: true).limit(to: limit)
            .getDocuments { (docData, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    completion(nil, false)
                } else {
                    guard let doc = docData else {
                        print("error")
                        return
                    }
                    
                    var popularTests: [TestModel] = []
                    
                    for document in doc.documents {
                        if let model = try? FirebaseDecoder().decode(TestModel.self, from: document.data()) {
                            let test = model
                            popularTests.append(test)
                        } else {
                            print("DEV: no data, sorry :-(")
                        }
                    }
                    completion(popularTests, true)
                }
            }
    }
    
    // TODO: it should be in different place
    private func errorDescription(error: Error) -> String {
        let errorCode = error._code
        
        switch errorCode {
        case AuthErrorCode.invalidEmail.rawValue:
            return ErrorsDescription.emailInvalid
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return ErrorsDescription.emailAlreadyInUse
        case AuthErrorCode.missingEmail.rawValue:
            return ErrorsDescription.emailEmpty
        case AuthErrorCode.weakPassword.rawValue:
            return ErrorsDescription.weakPassword
        case AuthErrorCode.wrongPassword.rawValue:
            return ErrorsDescription.wrongPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return ErrorsDescription.emailAlreadyInUse
        case AuthErrorCode.userNotFound.rawValue:
            return ErrorsDescription.userNotFound
        default:
            return ErrorsDescription.unknownError
        }
    }
    
    public func getTestById(testId: String, completion: @escaping (TestModel?, Error?) -> Void) {
        let docRef = db.collection(Constants.FStore.collectionTests).document(testId)
        
        docRef.getDocument { (doc, error) in
            guard let doc = doc else {
                return
            }
            if let model = try? FirebaseDecoder().decode(TestModel.self, from: doc.data()) {
                var test = model
                test.id = docRef.documentID
                completion(test, nil)
            } else {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    public func getSingedUser() -> UserModel? {
        if let user = Auth.auth().currentUser {
            guard let email = user.email else {
                return nil
            }
            let signedUser = UserModel(email: email)
            return signedUser
        }
        return nil
    }
    
    public func getUserStats(user: UserModel, completion: @escaping (StatsModel?, Error?) -> Void) {
        db.collection(Constants.FStore.collectionStats).whereField("user.email", isEqualTo: user.email).getDocuments { (documents, error) in
            guard let doc = documents else {
                print("EE: in getUserStats")
                return
            }
            if let model = try? FirebaseDecoder().decode(StatsModel.self, from: doc.documents.first?.data()) {
                print(model.user.email)
                let statsModel = model
                completion(statsModel, nil)
            } else {
                print("error in encoding")
                completion(nil, error)
            }
        }
    }
    
    public func updateStats(user: UserModel, categoryName: String, goodAnswers: Int, badAnswers: Int, completion: @escaping (Bool) -> Void) {
        getUserStats(user: user) { (statsModel, error) in
            guard let oldStatsModel = statsModel else {
                return
            }
            var newStatsModel = oldStatsModel
            newStatsModel.allTestsCompleted += 1
            for i in 0 ..< newStatsModel.statsByCategory.count {
                if newStatsModel.statsByCategory[i].categoryName == categoryName {
                    newStatsModel.statsByCategory[i].testsCompleted += 1
                    newStatsModel.statsByCategory[i].allBadAnswers += badAnswers
                    newStatsModel.statsByCategory[i].allGoodAnswers += goodAnswers
                    break
                }
            }
            
            self.db.collection(Constants.FStore.collectionStats).whereField("user.email", isEqualTo: user.email).getDocuments { (doc, error) in
                guard let document = doc else {
                    return
                }
                let singleDoc = document.documents.first
                guard let docID = singleDoc?.documentID else {
                    return
                }
                guard let docData = try? FirestoreEncoder().encode(newStatsModel) else {
                    return
                }
                self.db.collection(Constants.FStore.collectionStats).document(docID).updateData(docData) { error in
                    if let error = error {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func deleteTest(testId: String, completion: @escaping (Bool?) -> Void) {
        let docRef = db.collection(Constants.FStore.collectionTests).document(testId)
        
        // TODO: - check if record with testid exists and return completion false
        
        
        docRef.delete() { (error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    public func initializeStats(user: UserModel, completion: @escaping (Bool?) -> Void) {
        var categories2: [CategoryModel] = []
        self.getAllCategories { (categories, isSuccess) in
            guard let categories = categories else {
                print("EE: no categories!")
                return
            }
            categories2 = categories
            var statsByCat: [CategoriesStatsModel] = []
            for category in categories2 {
                statsByCat.append(CategoriesStatsModel(categoryName: category.name, testsCompleted: 0, allGoodAnswers: 0, allBadAnswers: 0))
            }
            let statsModel = StatsModel(user: user,
                                        allTestsCompleted: 0,
                                        statsByCategory: statsByCat)
            guard let docData = try? FirestoreEncoder().encode(statsModel) else {
                print("error while encode")
                return
            }
            self.db.collection(Constants.FStore.collectionStats).addDocument(data: docData) { (error) in
                if let error = error {
                    print("Dev: \(error.localizedDescription)")
                    completion(false)
                    fatalError()
                } else {
                    completion(true)
                }
            }
        }
    }
}

// MARK: - UserOperations
extension DbManager {
    
    /// The function responsible for registering new user.
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: function's completion returns `Bool` with information about register (`true` - success, `false` - not success) and String with error/successful message about register
    public func registerUser(email: String?,
                             password: String?,
                             completion: @escaping (Bool?, String?) -> Void) {
        guard let email = email, let password = password else {
            let message = ErrorsDescription.emailOrPasswordMissing
            completion(false, message)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                let message = self.errorDescription(error: error!)
                completion(false, message)
            } else {
                let message = SuccessDescription.registerSuccess
                completion(true, message)
                self.initializeStats(user: UserModel(email: email)) { (isSuccess) in
                    if let success = isSuccess {
                        print("Added stats")
                    }
                }
            }
        }
    }
    
    /// The function responsible for logging in the user.
    /// - Parameters:
    ///   - email: user's email
    ///   - password: user's password
    ///   - completion: function's completion returns Bool with information about sign in (true - success, false - not success) and String with error/successful message about sign in
    public func signInUser(email: String?,
                           password: String?,
                           completion: @escaping (Bool?, String?) -> Void) {
        guard let email = email, let password = password else {
            print("Missing email or password!")
            let message = ErrorsDescription.emailOrPasswordMissing
            completion(false, message)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                let message = self.errorDescription(error: error!)
                completion(false, message)
            } else {
                let message = SuccessDescription.signInSuccess
                completion(true, message)
                return
            }
        }
    }
    
    /// The function responsible for logging out the user.
    /// - Parameter completion: function's completion returns Bool with information about sign out (true - success, false - not success) and String with error/successful message about sign out
    public func signOutUser(completion: @escaping (Bool, String?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@!", signOutError)
            let message = ErrorsDescription.logoutError
            completion(false, message)
        }
    }
    
    public func getCurrentUser() -> UserModel? {
        let user = Auth.auth().currentUser
        
        guard let userEmail = user?.email else {
            return nil
        }
        let userM = UserModel(email: userEmail)
        
        return userM
    }
}

// MARK: - TestOperations
extension DbManager {
    
    /// Gets `TestModel` object, encodes, and saving it as a new record in database
    /// - Parameters:
    ///   - test: object of structure `TestModel`
    ///   - completion: It returns `true` if the operation was successful, or `false` if errors were found.
    public func saveTest(test: TestModel, completion: @escaping (Bool) -> Void) {
        guard let docData = try? FirestoreEncoder().encode(test) else {
            return
        }
        db.collection(Constants.FStore.collectionTests).addDocument(data: docData) { (error) in
            if let error = error {
                print("Dev: \(error.localizedDescription)")
                completion(false)
                fatalError()
            } else {
                completion(true)
            }
        }
    }
    
    /// Gets `TestModel` object and overwrites it in database.
    /// - Parameters:
    ///   - test: `TestModel` object to be written to the database.
    ///   - completion: It returns `true` if the operation was successful, or `false` if errors were found.
    public func updateTest(test: TestModel, completion: @escaping (Bool) -> Void) {
        guard let docData = try? FirestoreEncoder().encode(test), let testId = test.id else {
            return
        }
        
        let docRef = db.collection(Constants.FStore.collectionTests).document(testId)
        
        docRef.updateData(docData) { (error) in
            if let error = error {
                print("Dev: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    /// Returns tests of the given category from database
    /// - Parameters:
    ///   - category: Given category type
    ///   - completion: return array of `TestModel` or `Error`
    public func getTestsByCategory(category: String, completion: @escaping ([TestModel]?, Error?) -> Void) {
        var tests: [TestModel] = []
        
        db.collection(Constants.FStore.collectionTests).whereField("category", isEqualTo: category)
            .getDocuments() { (doc, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil, err)
                } else {
                    
                    guard let doc = doc else {
                        return
                    }
                    
                    for document in doc.documents {
                        if let model = try? FirebaseDecoder().decode(TestModel.self, from: document.data()) {
                            var test = model
                            test.id = document.documentID
                            tests.append(test)
                        } else {
                            print("DEV: no data, sorry :-(")
                        }
                    }
                }
                completion(tests, nil)
            }
    }
    
    /// Gets `TestModel` object and overwrites in database its average rating.
    /// - Parameters:
    ///   - testId: Id of test from database
    ///   - rating: The rating by which to update the object.
    ///   - completion: It returns `true` if the operation was successful, or `false` if errors were found.
    public func updateTestRating(testId: String, rating: Double, completion: @escaping (Bool) -> Void) {
        self.getTestById(testId: testId) { (doc, error) in
            guard let test = doc else {
                print("Early exit in dbmanager")
                return
            }
            let newRatingCounter = test.ratingsCounter + 1
            let newRating = (test.rating * Double(test.ratingsCounter) + rating) / (Double(newRatingCounter))
            let newPopularity = test.popularity + 1
            
            let updatedTest = TestModel(id: testId, name: test.name, category: test.category, description: test.description, difficultyLevel: test.difficultyLevel, rating: newRating, ratingsCounter: newRatingCounter, time: test.time, popularity: newPopularity, questions: test.questions, owner: test.owner)
            
            self.updateTest(test: updatedTest) { (isSuccess) in
                if(isSuccess) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    public func getUserTests(completion: @escaping ([TestModel]?, Error?) -> Void) {
        
        guard let user = self.getCurrentUser() else {
            print("No user found!")
            return
        }
        
        db.collection(Constants.FStore.collectionTests).whereField("owner.email", isEqualTo: user.email )
            .getDocuments { (docs, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    completion(nil, err)
                } else {
                    
                    guard let docs = docs else {
                        print("Docs empty!")
                        return
                    }
                    
                    var tests: [TestModel] = []
                    
                    for document in docs.documents {
                        if let model = try? FirebaseDecoder().decode(TestModel.self, from: document.data()) {
                            //print("DEV: model \(model)")
                            var test = model
                            test.id = document.documentID
                            print(test.id)
                            tests.append(test)
                        } else {
                            print("DEV: no data, sorry :-(")
                        }
                    }
                    completion(tests, nil)
                }
            }
    }
}
