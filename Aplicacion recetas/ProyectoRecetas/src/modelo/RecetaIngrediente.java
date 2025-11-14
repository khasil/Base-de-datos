package modelo;

/**
 * Modelo de Receta-Ingrediente
 * Representa la relación entre una receta y sus ingredientes
 */
public class RecetaIngrediente {
    private int idReceta;
    private int idIngrediente;
    private double cantidad;
    private String nombreIngrediente;
    private String unidadMedida;

    // Constructor vacío
    public RecetaIngrediente() {}

    // Constructor con parámetros
    public RecetaIngrediente(int idReceta, int idIngrediente, double cantidad) {
        this.idReceta = idReceta;
        this.idIngrediente = idIngrediente;
        this.cantidad = cantidad;
    }

    // Getters y Setters
    public int getIdReceta() {
        return idReceta;
    }

    public void setIdReceta(int idReceta) {
        this.idReceta = idReceta;
    }

    public int getIdIngrediente() {
        return idIngrediente;
    }

    public void setIdIngrediente(int idIngrediente) {
        this.idIngrediente = idIngrediente;
    }

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public String getNombreIngrediente() {
        return nombreIngrediente;
    }

    public void setNombreIngrediente(String nombreIngrediente) {
        this.nombreIngrediente = nombreIngrediente;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    @Override
    public String toString() {
        return cantidad + " " + unidadMedida + " de " + nombreIngrediente;
    }
}