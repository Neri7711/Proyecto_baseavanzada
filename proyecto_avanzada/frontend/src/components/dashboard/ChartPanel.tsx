import { ReactNode } from "react";
import { LucideIcon } from "lucide-react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface ChartPanelProps {
  title: string;
  subtitle?: string;
  icon?: LucideIcon;
  action?: ReactNode;
  children: ReactNode;
  className?: string;
  contentClassName?: string;
}

export function ChartPanel({
  title,
  subtitle,
  icon: Icon,
  action,
  children,
  className,
  contentClassName,
}: ChartPanelProps) {
  return (
    <Card
      className={cn(
       "rounded-3xl border border-white/70 bg-white/85 backdrop-blur-xl shadow-[0_12px_35px_rgba(124,58,237,0.10)] transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_18px_50px_rgba(6,182,212,0.16)]",
        className
      )}
    >
      <CardHeader className="flex flex-row items-start justify-between gap-4 space-y-0 p-6 pb-4">
        <div className="flex items-start gap-3">
          {Icon && (
            <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-violet-500/15 to-cyan-400/15 text-primary shadow-sm">
              <Icon className="h-5 w-5" />
            </div>
          )}

          <div>
            <h3 className="text-lg font-extrabold tracking-tight text-foreground">
              {title}
            </h3>
            {subtitle ? (
              <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
                {subtitle}
              </p>
            ) : null}
          </div>
        </div>

        {action ? <div className="shrink-0">{action}</div> : null}
      </CardHeader>

      <CardContent className={cn("px-6 pb-6 pt-1", contentClassName)}>
        {children}
      </CardContent>
    </Card>
  );
}
