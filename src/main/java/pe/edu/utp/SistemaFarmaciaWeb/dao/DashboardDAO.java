/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;

public class DashboardDAO {

    // Total de clientes activos
    public int getTotalClientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Clientes WHERE estado = 1";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) {
            System.err.println("Error Total Clientes: " + e.getMessage());
        }
        return total;
    }

    // Total de medicamentos catalogados activos
    public int getTotalMedicamentos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Medicamentos WHERE estado = 1";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt("total");
        } catch (Exception e) {
            System.err.println("Error Total Medicamentos: " + e.getMessage());
        }
        return total;
    }

    // Alertas: Lotes vencidos o por vencer en los próximos 60 días
    public int getLotesPorVencer() {
        int alertas = 0;
        String sql = "SELECT COUNT(*) AS alertas FROM LotesMedicamentos " +
                     "WHERE estado = 1 AND fecha_vencimiento <= DATEADD(day, 60, CAST(GETDATE() AS DATE))";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) alertas = rs.getInt("alertas");
        } catch (Exception e) {
            System.err.println("Error Alertas Vencimiento: " + e.getMessage());
        }
        return alertas;
    }

    // Medicamentos cuyo stock total está por debajo o igual a su stock mínimo
    public int getMedicamentosBajoStock() {
        int alertas = 0;
        String sql = "SELECT COUNT(*) AS alertas FROM Medicamentos m " +
                     "WHERE m.estado = 1 AND m.stock_minimo >= (" +
                     "    SELECT ISNULL(SUM(lm.stock_actual), 0) " +
                     "    FROM LotesMedicamentos lm " +
                     "    WHERE lm.id_medicamento = m.id_medicamento AND lm.estado = 1 " +
                     "    AND lm.fecha_vencimiento >= CAST(GETDATE() AS DATE)" +
                     ")";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) alertas = rs.getInt("alertas");
        } catch (Exception e) {
            System.err.println("Error Alertas Stock Minimo: " + e.getMessage());
        }
        return alertas;
    }
}
