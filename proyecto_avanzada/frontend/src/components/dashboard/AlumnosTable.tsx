import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import type { Alumno } from "@/lib/api";

const statusVariant = (s: string) => {
  if (s === "Activo") return "default";
  if (s === "Baja") return "destructive";
  return "secondary";
};

export function AlumnosTable({ data }: { data: Alumno[] | undefined }) {
  if (!data?.length) return null;
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold">Listado de Alumnos</CardTitle>
      </CardHeader>
      <CardContent className="overflow-auto max-h-[400px]">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Alumno</TableHead>
              <TableHead>Carrera</TableHead>
              <TableHead>Correo</TableHead>
              <TableHead>Estatus</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.slice(0, 50).map((a) => (
              <TableRow key={a.id_alumno}>
                <TableCell className="font-medium">{a.alumno}</TableCell>
                <TableCell>{a.carrera ?? "—"}</TableCell>
                <TableCell className="text-muted-foreground text-sm">{a.correo ?? "—"}</TableCell>
                <TableCell><Badge variant={statusVariant(a.estatus_alumno)}>{a.estatus_alumno}</Badge></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  );
}
