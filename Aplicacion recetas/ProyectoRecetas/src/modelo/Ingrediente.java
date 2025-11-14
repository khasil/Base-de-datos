package modelo;

/**
 * Modelo de Ingrediente
 * Representa un ingrediente que se puede usar en recetas
 */
public class Ingrediente {
    private int idIngrediente;
    private String nombre;
    private String unidadMedida;

    // Constructor vacío
    public Ingrediente() {}

    // Constructor con parámetros
    public Ingrediente(int idIngrediente, String nombre, String unidadMedida) {
        this.idIngrediente = idIngrediente;
        this.nombre = nombre;
        this.unidadMedida = unidadMedida;
    }

    // Getters y Setters
    public int getIdIngrediente() {
        return idIngrediente;
    }

    public void setIdIngrediente(int idIngrediente) {
        this.idIngrediente = idIngrediente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    @Override
    public String toString() {
        return nombre + " (" + unidadMedida + ")";
    }
}