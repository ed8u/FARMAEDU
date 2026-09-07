/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Medicamento;

public class MedicamentoDAO {

    public List<Medicamento> listarTodos() {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT m.id_medicamento, m.codigo_barras, m.nombre_comercial, m.concentracion, " +
                     "       m.precio_compra_ref, m.precio_venta, m.stock_minimo, m.receta_obligatoria, m.estado, " +
                     "       m.id_principio, m.id_forma, m.id_presentacion, m.id_laboratorio, m.id_categoria, " +
                     "       p.nombre_principio, f.nombre_forma, pr.nombre_presentacion, " +
                     "       l.nombre_laboratorio, c.nombre_categoria, " +
                     "       ISNULL((SELECT SUM(lm.stock_actual) FROM LotesMedicamentos lm " +
                     "               WHERE lm.id_medicamento = m.id_medicamento AND lm.estado = 1 " +
                     "               AND lm.fecha_vencimiento >= CAST(GETDATE() AS DATE)), 0) AS stock_total " +
                     "FROM Medicamentos m " +
                     "INNER JOIN PrincipiosActivos p ON m.id_principio = p.id_principio " +
                     "INNER JOIN FormasFarmaceuticas f ON m.id_forma = f.id_forma " +
                     "INNER JOIN Presentaciones pr ON m.id_presentacion = pr.id_presentacion " +
                     "INNER JOIN Laboratorios l ON m.id_laboratorio = l.id_laboratorio " +
                     "INNER JOIN Categorias c ON m.id_categoria = c.id_categoria " +
                     "WHERE m.estado = 1 ORDER BY m.nombre_comercial ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicamento med = new Medicamento();
                med.setIdMedicamento(rs.getInt("id_medicamento"));
                med.setCodigoBarras(rs.getString("codigo_barras"));
                med.setNombreComercial(rs.getString("nombre_comercial"));
                med.setConcentracion(rs.getString("concentracion"));
                med.setPrecioCompraRef(rs.getBigDecimal("precio_compra_ref"));
                med.setPrecioVenta(rs.getBigDecimal("precio_venta"));
                med.setStockMinimo(rs.getInt("stock_minimo"));
                med.setRecetaObligatoria(rs.getBoolean("receta_obligatoria"));
                med.setEstado(rs.getBoolean("estado"));

                med.setIdPrincipio(rs.getInt("id_principio"));
                med.setIdForma(rs.getInt("id_forma"));
                med.setIdPresentacion(rs.getInt("id_presentacion"));
                med.setIdLaboratorio(rs.getInt("id_laboratorio"));
                med.setIdCategoria(rs.getInt("id_categoria"));

                med.setNombrePrincipio(rs.getString("nombre_principio"));
                med.setNombreForma(rs.getString("nombre_forma"));
                med.setNombrePresentacion(rs.getString("nombre_presentacion"));
                med.setNombreLaboratorio(rs.getString("nombre_laboratorio"));
                med.setNombreCategoria(rs.getString("nombre_categoria"));
                med.setStockTotal(rs.getInt("stock_total"));

                lista.add(med);
            }
        } catch (Exception e) {
            System.err.println("Error al listar medicamentos: " + e.getMessage());
        }
        return lista;
    }

    public boolean registrar(Medicamento med) {
        String sql = "INSERT INTO Medicamentos (codigo_barras, nombre_comercial, id_principio, id_forma, " +
                     "concentracion, id_presentacion, id_laboratorio, id_categoria, precio_compra_ref, " +
                     "precio_venta, stock_minimo, receta_obligatoria) " +
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
            ps.setBigDecimal(9, med.getPrecioCompraRef());
            ps.setBigDecimal(10, med.getPrecioVenta());
            ps.setInt(11, med.getStockMinimo());
            ps.setBoolean(12, med.isRecetaObligatoria());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar medicamento: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Medicamento med) {
        String sql = "UPDATE Medicamentos SET codigo_barras=?, nombre_comercial=?, id_principio=?, " +
                     "id_forma=?, concentracion=?, id_presentacion=?, id_laboratorio=?, id_categoria=?, " +
                     "precio_compra_ref=?, precio_venta=?, stock_minimo=?, receta_obligatoria=? " +
                     "WHERE id_medicamento=?";

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
            ps.setBigDecimal(9, med.getPrecioCompraRef());
            ps.setBigDecimal(10, med.getPrecioVenta());
            ps.setInt(11, med.getStockMinimo());
            ps.setBoolean(12, med.isRecetaObligatoria());
            ps.setInt(13, med.getIdMedicamento());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al actualizar medicamento: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarLogico(int id) {
        String sql = "UPDATE Medicamentos SET estado = 0 WHERE id_medicamento = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al eliminar medicamento: " + e.getMessage());
            return false;
        }
    }
}
