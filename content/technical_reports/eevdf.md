# EEVDF



### Eligibility Check in code

*/kernel/sched/fair.c*
```C
int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
{
	return vruntime_eligible(cfs_rq, se->vruntime);
}
```
