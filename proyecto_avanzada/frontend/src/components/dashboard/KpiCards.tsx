import { Users, GraduationCap, DollarSign, BookOpen, TrendingDown, AlertCircle } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import type { KPIs } from "@/lib/api";

interface Props {
  data: KPIs | undefined;
  isLoading: boolean;
}

const cards = [
  {
    key: "total_alumnos" as const,
    label: "Total Alumnos",
    icon: Users,
    color: "bg-violet-500",
    helper: "Matrícula activa registrada",
  },
  {
    key: "rendimiento_global" as const,
    label: "Rendimiento Global",
    icon: GraduationCap,
    color: "bg-cyan-500",
    suffix: "%",
    helper: "Promedio acumulado institucional",
  },
  {
    key: "tasa_reprobacion" as const,
    label: "Tasa Reprobación",
    icon: TrendingDown,
    color: "bg-pink-500",
    suffix: "%",
    helper: "Materias con mayor riesgo",
  },
  {
    key: "porcentaje_pagos_corriente" as const,
    label: "Pagos al Corriente",
    icon: DollarSign,
    color: "bg-orange-400",
    suffix: "%",
    helper: "Cartera al día",
  },
  {
    key: "deuda_pendiente" as const,
    label: "Deuda Pendiente",
    icon: AlertCircle,
    color: "bg-rose-500",
    prefix: "$",
    format: true,
    helper: "Saldo acumulado por cobrar",
  },
  {
    key: "docentes_activos" as const,
    label: "Docentes Activos",
    icon: BookOpen,
    color: "bg-emerald-500",
    helper: "Profesores con carga vigente",
  },
];
export function KpiCards({ data, isLoading }: Props) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
      {cards.map((c) => (
        <Card
          key={c.key}
          className="group overflow-hidden rounded-3xl border border-white/60 bg-white/80 backdrop-blur-xl shadow-[0_12px_35px_rgba(15,23,42,0.08)] transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_18px_50px_rgba(15,23,42,0.14)]"
        >
          <CardContent className="p-0">
            <div className="flex items-stretch">
              <div className={`w-2 ${c.color}`} />
              <div className="flex-1 p-5">
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="text-sm font-semibold text-muted-foreground">{c.label}</p>
                    {isLoading ? (
                      <div className="h-9 w-28 bg-muted animate-pulse rounded-xl mt-3" />
                    ) : (
                      <p className="mt-2 text-3xl font-black tracking-tight text-foreground">
                        {data ? (
                          <>
                            {(() => {
                              const raw = data[c.key];
                              const value = typeof raw === "number" ? raw : Number(raw ?? 0);
                              return (
                                <>
                                  {c.prefix ?? ""}
                                  {c.format ? value.toLocaleString() : value}
                                  {c.suffix ?? ""}
                                </>
                              );
                            })()}
                          </>
                        ) : "—"}
                      </p>
                    )}
                  </div>

                  <div className={`${c.color} rounded-2xl p-3 text-white shadow-lg transition-transform duration-300 group-hover:scale-105`}>
                    <c.icon className="h-6 w-6" />
                  </div>
                </div>

                <div className="mt-4 flex items-center justify-between gap-3">
                  <p className="text-xs text-muted-foreground">{c.helper}</p>
                  <div className="h-2 w-24 overflow-hidden rounded-full bg-muted">
                    <div className={`h-full ${c.color} w-2/3 rounded-full`} />
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
