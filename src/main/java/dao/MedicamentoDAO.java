package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import modelo.Medicamento;

public class MedicamentoDAO {

    public List<Medicamento> listarTodos() {
        List<Medicamento> lista = new ArrayList<>();
        // Query con JOIN para traer los nombres de las categorías, laboratorios, etc.
        String sql = "SELECT m.*, p.nombre AS principio, f.nombre AS forma, pr.nombre AS presentacion, " +
                     "l.nombre AS laboratorio, c.nombre AS categoria " +
                     "FROM Medicamentos m " +
                     "INNER JOIN Principios_Activos p ON m.id_principio = p.id_principio " +
                     "INNER JOIN Formas_Farmaceuticas f ON m.id_forma = f.id_forma " +
                     "INNER JOIN Presentaciones pr ON m.id_presentacion = pr.id_presentacion " +
                     "INNER JOIN Laboratorios l ON m.id_laboratorio = l.id_laboratorio " +
                     "INNER JOIN Categorias c ON m.id_categoria = c.id_categoria " +
                     "WHERE m.estado = 1";
        
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Medicamento med = new Medicamento();
                med.setIdMedicamento(rs.getInt("id_medicamento"));
                med.setCodigoBarras(rs.getString("codigo_barras"));
                med.setNombreComercial(rs.getString("nombre_comercial"));
                med.setConcentracion(rs.getString("concentracion"));
                med.setPrecioCompraRef(rs.getDouble("precio_compra_ref"));
                med.setPrecioVenta(rs.getDouble("precio_venta"));
                
                // Nombres obtenidos por el JOIN
                med.setNombrePrincipio(rs.getString("principio"));
                med.setNombreForma(rs.getString("forma"));
                med.setNombrePresentacion(rs.getString("presentacion"));
                med.setNombreLaboratorio(rs.getString("laboratorio"));
                med.setNombreCategoria(rs.getString("categoria"));
                
                lista.add(med);
            }
        } catch (Exception e) {
            System.out.println("Error al listar medicamentos: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(Medicamento med) {
        String sql = "INSERT INTO Medicamentos (codigo_barras, nombre_comercial, id_principio, id_forma, concentracion, " +
                     "id_presentacion, id_laboratorio, id_categoria, receta_obligatoria, precio_compra_ref, precio_venta, stock_minimo) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, med.getCodigoBarras());
            ps.setString(2, med.getNombreComercial());
            ps.setInt(3, med.getIdPrincipio());
            ps.setInt(4, med.getIdForma());
            ps.setString(5, med.getConcentracion());
            ps.setInt(6, med.getIdPresentacion());
            ps.setInt(7, med.getIdLaboratorio());
            ps.setInt(8, med.getIdCategoria());
            ps.setBoolean(9, med.isRecetaObligatoria());
            ps.setDouble(10, med.getPrecioCompraRef());
            ps.setDouble(11, med.getPrecioVenta());
            ps.setInt(12, med.getStockMinimo());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al registrar medicamento: " + e.getMessage());
            return false;
        }
    }
    
    // Método para borrado lógico
    public boolean eliminar(int id) {
        String sql = "UPDATE Medicamentos SET estado = 0 WHERE id_medicamento = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al eliminar medicamento: " + e.getMessage());
            return false;
        }
    }
}