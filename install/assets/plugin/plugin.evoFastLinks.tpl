/**
 * evoFastLinks
 *
 * Быстрые ссылки на ресурсы дерева, модули и чанки в верхнее меню
 *
 * @author      webber (web-ber12@yandex.ru)
 * @category    plugin
 * @version     0.2
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @events OnManagerMenuPrerender,OnManagerNodeRender
 * @internal    @properties &ids=Список id ресурсов через запятую;text;&modules=Список id модулей через запятую;text;&chunks=Список id чанков через запятую;text;&tabname=Название пункта в верхнем меню;text;БЫСТРЫЕ ССЫЛКИ&position=Позиция в меню;text;15;&hidefromtree=Скрывать непапки из дерева;text;0
 * @internal    @installset base, sample
 * @internal    @modx_category Manager and Admin 
 */
$e = &$modx->event;
switch ($e->name) {
    case 'OnManagerMenuPrerender':
        $docs = array_filter(array_map('trim', explode(',', $ids)));
        $modules = array_filter(array_map('trim', explode(',', $modules)));
        $chunks = array_filter(array_map('trim', explode(',', $chunks)));
        $arr = array('docs' => $docs, 'modules' => $modules, 'chunks' => $chunks);
        $cnt = count($docs) + count($modules) + count($chunks);
        $position = (int)$position > 0 ? (int)$position : 15;
        if ($cnt > 0) {
            $href = '';
            switch (true) {
                case (count($docs) > 0):
                    $href = 'index.php?a=27&r=1&id=' . $docs[0];
                    break;
                case (count($modules) > 0):
                    $href = 'index.php?a=112&id=' . $modules[0];
                    break;
                case (count($chunks) > 0):
                    $href = 'index.php?a=78&id=' . $chunks[0];
                    break;
                default:
                    break;
            }
            $menu['fast_links'] = array(
                'fast_links',
                'main',
                '<i class="fa fa-cog"></i> ' . $tabname,
                $href,
                $tabname,
                '',
                '',
                'main',
                0,
                $position,
                '',
               );
        }
        if ($cnt > 1) {
            $menu['fast_links'][3] = 'javascript:;';
            $menu['fast_links'][5] = ' return false;';
            $i = 1;
            $icon = 'fa-cog';
            foreach ($arr as $k => $v) {
                $sql = '';
                switch (true) {
                    case ($k == 'docs' && count($v) > 0):
                        $sql = "SELECT id,pagetitle as name FROM " . $modx->getFullTableName("site_content") . " WHERE id IN(" . implode(',', $v) . ")";
                        $tpl = 'index.php?a=27&r=1&id=[+id+]';
                        $icon = 'fa-file-o';
                        break;
                    case ($k == 'modules' && count($v) > 0):
                        $sql = "SELECT id,name as name FROM " . $modx->getFullTableName("site_modules") . " WHERE id IN(" . implode(',', $v) . ")";
                        $tpl = 'index.php?a=112&id=[+id+]';
                        $icon = 'fa-cubes';
                        break;
                    case ($k == 'chunks' && count($v) > 0):
                        $sql = "SELECT id,description as name FROM " . $modx->getFullTableName("site_htmlsnippets") . " WHERE id IN(" . implode(',', $v) . ")";
                        $tpl = 'index.php?a=78&id=[+id+]';
                        $icon = 'fa-th-large';
                        break;
                    default:
                        break;
                }
                if ($sql != '') {
                    $q = $modx->db->query($sql);
                    while ($row = $modx->db->getRow($q)) {
                        $menu['fast_links' . $i] = array(
                            'fast_links' . $i,
                            'fast_links',
                            $modx->parseText('<i class="fa [+icon+]"></i> ' . $row['name'], array('icon' => $icon)),
                            $modx->parseText($tpl, array('id' => $row['id'])),
                            $row['name'],
                            '',
                            '',
                            'main',
                            0,
                            $i,
                            '',
                           );
                        $i++;
                    }
                }
            }
        }
        $e->output(serialize($menu));
        break;
    case 'OnManagerNodeRender':
        $list_id = explode(',', $ids);
        $list_id = array_map('trim', $list_id);
        if ($hidefromtree && $hidefromtree == '1' && in_array($id, $list_id) && $isfolder != '1') {
            $e->output(' ');
        }
        break;
}