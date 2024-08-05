import Foundation
import CoreData
import UIKit

func agregarProductoAlCarrito (producto: Producto) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    
    if let resultado = encontrarProducto(productoId: producto.productoId) {
        let entidad = resultado
        entidad.cantidad += 1
    } else {
        let entidad = CarritoEntity(context: manageContext)
        entidad.productoId = producto.productoId
        entidad.descripcion = producto.descripcion
        entidad.categoriaId = producto.categoriaId
        entidad.producto = producto.producto
        entidad.productoImg = producto.productoImg
        entidad.unidades = producto.unidades
        entidad.precio = producto.precio
        entidad.cantidad = 1
    }
    
    do {
        try manageContext.save()
    } catch let error as NSError{
        print("Se presento un error \(error)")
    }
}

func listarCarrito(completion: @escaping([CarritoEntity]) -> Void){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    var carritoLista:[CarritoEntity] = []
    
    do {
        let carritoCoreData = try manageContext.fetch(CarritoEntity.fetchRequest())
        carritoLista = carritoCoreData
        
    } catch let error as NSError{
        print("Se presento un error \(error)")
    }
    completion(carritoLista)
}

func encontrarProducto (productoId: String) -> CarritoEntity?{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    var resultado: CarritoEntity?
    
    do {
        let request: NSFetchRequest<CarritoEntity> = CarritoEntity.fetchRequest()
        let predicado = NSPredicate(format: "productoId == %@", productoId)
        request.predicate = predicado
        
        resultado = try manageContext.fetch(request).first
    } catch let error as NSError {
        print("Se presento un error \(error)")
    }
    return resultado
}

func eliminarProducto(producto: CarritoEntity) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    
    manageContext.delete(producto)
    
    do {
        try manageContext.save()
    } catch let error as NSError{
        print("Se presento un error \(error)")
    }
}

func editarCantidadProducto(producto: CarritoEntity, accion: String) -> Int16 {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    
    switch accion {
    case "+":
        producto.cantidad += 1
    case "-":
        if producto.cantidad > 1 {
            producto.cantidad -= 1
        }
    default:
        producto.cantidad = 0
    }
    
    do {
        try manageContext.save()
    } catch let error as NSError{
        print("Se presento un error \(error)")
    }
    
    return producto.cantidad
}

func limpiarCarrito(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CarritoEntity")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try manageContext.execute(deleteRequest)
        try manageContext.save()
    } catch let error as NSError{
        print("Se presento un error \(error)")
    }
}
