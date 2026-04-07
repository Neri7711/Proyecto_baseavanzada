import { Inbox, Loader2 } from "lucide-react";

export function PanelLoading({
  message = "Cargando información...",
}: {
  message?: string;
}) {
  return (
    <div className="flex min-h-[260px] flex-col items-center justify-center rounded-2xl border border-dashed border-border bg-muted/40">
      <Loader2 className="h-8 w-8 animate-spin text-primary" />
      <p className="mt-3 text-sm font-medium text-muted-foreground">
        {message}
      </p>
    </div>
  );
}

export function PanelEmpty({
  message = "No hay datos disponibles",
}: {
  message?: string;
}) {
  return (
    <div className="flex min-h-[260px] flex-col items-center justify-center rounded-2xl border border-dashed border-border bg-muted/30">
      <Inbox className="h-8 w-8 text-muted-foreground" />
      <p className="mt-3 text-sm font-medium text-muted-foreground">
        {message}
      </p>
    </div>
  );
}
