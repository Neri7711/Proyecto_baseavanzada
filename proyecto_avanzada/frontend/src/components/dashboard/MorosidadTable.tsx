import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { AlertTriangle } from "lucide-react";
import type { MorosidadAlumno } from "@/lib/api";

export function MorosidadTable({ data }: { data: MorosidadAlumno[] | undefined }) {
  if (!data?.length) return (
    <Card className="border-none shadow-md">
      <CardHeader><CardTitle className="text-base font-semibold flex items-center gap-2"><AlertTriangle className="h-4 w-4 text-accent" />Morosidad</CardTitle></CardHeader>
      <CardContent><p className="text-muted-foreground text-sm">No hay alumnos morosos.</p></CardContent>
    </Card>
  );
  return (
    <Card className="border-none shadow-md">
      <CardHeader className="pb-2">
        <CardTitle className="text-base font-semibold flex items-center gap-2">
          <AlertTriangle className="h-4 w-4 text-accent" />
          Alumnos Morosos ({data.length})
        </CardTitle>
      </CardHeader>
      <CardContent className="overflow-auto max-h-[350px]">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Nombre</TableHead>
              <TableHead>Apellidos</TableHead>
              <TableHead>Correo</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.map((a, i) => (
              <TableRow key={i}>
                <TableCell className="font-medium">{a.nombre}</TableCell>
                <TableCell>{a.apellidos}</TableCell>
                <TableCell className="text-muted-foreground text-sm">{a.correo ?? "—"}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  );
}
