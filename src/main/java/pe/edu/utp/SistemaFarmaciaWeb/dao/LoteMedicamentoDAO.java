/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.LoteMedicamento;

public class LoteMedicamentoDAO {

    // Listado ordenado por fecha de vencimiento ascendente (FEFO)
    public List<LoteMedicamento> listarTodosFEFO() {
        List<LoteMedicamento> lista = new ArrayList<>();
        String sql = "SELECT lm.id_lote, lm.id_medicamento, lm.numero_lote, lm.fecha_vencimiento, " +
                     "       lm.stock_actual, lm.fecha_ingreso, lm.estado, " +
                     "       m.nombre_comercial, m.codigo_barras " +
                     "FROM LotesMedicamentos lm " +
                     "INNER JOIN Medicamentos m ON lm.id_medicamento = m.id_medicamento " +
                     "WHERE lm.estado = 1 " +
                     "ORDER BY lm.fecha_vencimiento ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                LoteMedicamento lote = new LoteMedicamento();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdMedicamento(rs.getInt("id_medicamento"));
                lote.setNumeroLote(rs.getString("numero_lote"));

                Date fVenc = rs.getDate("fecha_vencimiento");
                if (fVenc != null) {
                    lote.setFechaVencimiento(fVenc.toLocalDate());
                }

                lote.setStockActual(rs.getInt("stock_actual"));

                Timestamp fIng = rs.getTimestamp("fecha_ingreso");
                if (fIng != null) {
                    lote.setFechaIngreso(fIng.toLocalDateTime());
                }

                lote.setEstado(rs.getBoolean("estado"));
                lote.setNombreMedicamento(rs.getString("nombre_comercial"));
                lote.setCodigoBarras(rs.getString("codigo_barras"));

                lista.add(lote);
            }
        } catch (Exception e) {
            System.err.println("Error al listar lotes FEFO: " + e.getMessage());
        }
        return lista;
    }

    // Registrar un nuevo ingreso de lote / stock
    public boolean registrar(LoteMedicamento lote) {
        String sql = "INSERT INTO LotesMedicamentos (id_medicamento, numero_lote, fecha_vencimiento, stock_actual) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, lote.getIdMedicamento());
            ps.setString(2, lote.getNumeroLote());
            ps.setDate(3, Date.valueOf(lote.getFechaVencimiento()));
            ps.setInt(4, lote.getStockActual());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar lote de medicamento: " + e.getMessage());
            return false;
        }
    }

    // Borrado lógico de lote en caso de merma o error de digitación
    public boolean eliminarLogico(int idLote) {
        String sql = "UPDATE LotesMedicamentos SET estado = 0 WHERE id_lote = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idLote);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error al anular lote: " + e.getMessage());
            return false;
        }
    }
}
