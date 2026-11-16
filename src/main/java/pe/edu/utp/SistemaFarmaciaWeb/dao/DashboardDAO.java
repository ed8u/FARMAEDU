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
import pe.edu.utp.SistemaFarmaciaWeb.modelo.LoteMedicamento;

public class DashboardDAO {

    // Total de clientes activos
    public int getTotalClientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Clientes WHERE estado = 1";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            System.err.println("Error Total Clientes: " + e.getMessage());
        }
        return total;
    }

    // Total de medicamentos catalogados activos
    public int getTotalMedicamentos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Medicamentos WHERE estado = 1";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            System.err.println("Error Total Medicamentos: " + e.getMessage());
        }
        return total;
    }

    // Alertas: Lotes vencidos o por vencer en los próximos 60 días
    public int getLotesPorVencer() {
        int alertas = 0;
        String sql = "SELECT COUNT(*) AS alertas FROM LotesMedicamentos "
                + "WHERE estado = 1 AND fecha_vencimiento <= DATEADD(day, 60, CAST(GETDATE() AS DATE))";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                alertas = rs.getInt("alertas");
            }
        } catch (Exception e) {
            System.err.println("Error Alertas Vencimiento: " + e.getMessage());
        }
        return alertas;
    }

    // Medicamentos cuyo stock total está por debajo o igual a su stock mínimo
    public int getMedicamentosBajoStock() {
        int alertas = 0;
        String sql = "SELECT COUNT(*) AS alertas FROM Medicamentos m "
                + "WHERE m.estado = 1 AND m.stock_minimo >= ("
                + "    SELECT ISNULL(SUM(lm.stock_actual), 0) "
                + "    FROM LotesMedicamentos lm "
                + "    WHERE lm.id_medicamento = m.id_medicamento AND lm.estado = 1 "
                + "    AND lm.fecha_vencimiento >= CAST(GETDATE() AS DATE)"
                + ")";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                alertas = rs.getInt("alertas");
            }
        } catch (Exception e) {
            System.err.println("Error Alertas Stock Minimo: " + e.getMessage());
        }
        return alertas;
    }

    public List<LoteMedicamento> getLotesCriticosFEFO() {
        List<LoteMedicamento> l = new ArrayList<>();
        String sql = "SELECT TOP 4 m.nombre_comercial, lm.numero_lote, lm.stock_actual, "
                + "       DATEDIFF(DAY, CAST(GETDATE() AS DATE), lm.fecha_vencimiento) AS dias_para_vencer "
                + "FROM LotesMedicamentos lm "
                + "INNER JOIN Medicamentos m ON lm.id_medicamento = m.id_medicamento "
                + "WHERE lm.estado = 1 AND lm.stock_actual > 0 "
                + "  AND lm.fecha_vencimiento <= DATEADD(DAY, 60, CAST(GETDATE() AS DATE)) "
                + "ORDER BY lm.fecha_vencimiento ASC";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LoteMedicamento lote = new LoteMedicamento();
                lote.setNombreMedicamento(rs.getString("nombre_comercial"));
                lote.setNumeroLote(rs.getString("numero_lote"));
                lote.setStockActual(rs.getInt("stock_actual"));
                lote.setDiasParaVencer(rs.getInt("dias_para_vencer"));
                l.add(lote);
            }
        } catch (Exception e) {
            System.err.println("Error Lotes Críticos FEFO: " + e.getMessage());
        }
        return l;
    }
}
