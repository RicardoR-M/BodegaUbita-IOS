import Foundation
import Firebase

func firebaseGetProducts(collection:String, completion:  @escaping([Producto]) -> Void) {
    var productoList:[Producto] = []
    
    let db = Firestore.firestore()
    db.collection(collection).getDocuments() {(querySnapshot, error) in
        if error != nil {
            print("Se presentó un error")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                
                let productoId = document.documentID
                let categoriaId = data["categoryId"] as? String ?? ""
                let productoImg = data["image"] as? String ?? ""
                let descripcion = data["description"] as? String ?? ""
                let producto = data["name"] as? String ?? ""
                let unidades = data["unit"] as? String ?? ""
                let precio = data["price"] as? Double ?? 0
                
                productoList.append(Producto(productoId: productoId, categoriaId: categoriaId, productoImg: productoImg, producto: producto, unidades: unidades, precio: precio, descripcion: descripcion))
            }
            completion(productoList)
        }
    }
}

func firebaseGetCategories(collection:String, completion:  @escaping([Categoria]) -> Void) {
    var categoriaList:[Categoria] = []
    
    let db = Firestore.firestore()
    db.collection(collection).getDocuments() {(querySnapshot, error) in
        if error != nil {
            print("Se presentó un error")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                
                let categoriaId = document.documentID
                let categoriaImg = data["image"] as? String ?? ""
                let categoria = data["name"] as? String ?? ""
                let fondo = data["background"] as? String ?? ""
                
                categoriaList.append(Categoria(categoriaId: categoriaId, categoriaImg: categoriaImg, categoria: categoria, fondo: fondo))
                
            }
            completion(categoriaList)
        }
    }
}

func firebaseGetProductsByCategory(categoryId:String, completion: @escaping([Producto]) -> Void){
    var productoList:[Producto] = []
    
    let db = Firestore.firestore()
    db.collection("Producto").whereField("categoryId", isEqualTo: categoryId).getDocuments() {(querySnapshot, error) in
        if error != nil {
            print("Se presentó un error")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                
                let productoId = document.documentID
                let categoriaId = data["categoryId"] as? String ?? ""
                let productoImg = data["image"] as? String ?? ""
                let descripcion = data["description"] as? String ?? ""
                let producto = data["name"] as? String ?? ""
                let unidades = data["unit"] as? String ?? ""
                let precio = data["price"] as? Double ?? 0
                
                productoList.append(Producto(productoId: productoId, categoriaId: categoriaId, productoImg: productoImg, producto: producto, unidades: unidades, precio: precio, descripcion: descripcion))
            }
            completion(productoList)
        }
    }
}

func firebaseSaveOrder(carrito: [CarritoEntity], completion: @escaping() -> Void){
    let user = Auth.auth().currentUser
    let uid = user?.uid ?? ""
    var productos = [[String:Any]]()
    
    for item in carrito {
        let producto:[String:Any] = [
            "categoryId": item.categoriaId!,
            "description": item.descripcion!,
            "image": item.productoImg!,
            "name": item.producto!,
            "price": item.precio,
            "productId": item.productoId!,
            "quantity": item.cantidad,
            "unit": item.unidades!
        ]
        productos.append(producto)
    }
    
    let data:[String:Any] = [
        "date": Date(),
        "delivered": false,
        "userUid": uid,
        "products": productos
    ]
    
    let db = Firestore.firestore()
    db.collection("Order").document().setData(data) { error in
        if let err = error {
            print("Se presentó un error")
        }
    }
    completion()
}

func firebaseGetUserOrders(completion: @escaping([Pedido]) -> Void) {
    let user = Auth.auth().currentUser
    let uid = user?.uid ?? ""
    var pedidoList:[Pedido] = []
    
    let db = Firestore.firestore()
    db.collection("Order").whereField("userUid", isEqualTo: uid).getDocuments() {(querySnapshot, error) in
        if error != nil {
            print("Se presentó un error")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                let timestamp = data["date"] as! Timestamp
                let date = timestamp.dateValue()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: date)
                
                let pedido = Pedido(codigo: document.documentID,
                                    fecha: dateString,
                                    estado: data["delivered"] as? Bool ?? false)
                pedidoList.append(pedido)
            }
            completion(pedidoList)
        }
    }
}
