struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
